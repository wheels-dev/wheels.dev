# Docker Swarm Deployment Guide

> Reference for Claude instances and developers deploying web applications to the PAI Industries Docker Swarm.

## Architecture Overview

```
Internet → Cloudflare (SSL termination) → cloudflared tunnel → Traefik (port 80) → App container
```

- **SSL is handled by Cloudflare** — do NOT configure TLS/HTTPS in your app or Traefik labels
- **Traefik routes by hostname** on port 80 (`web` entrypoint) using Docker Swarm labels
- **cloudflared** runs as a Swarm service on the `proxy` network, forwarding to `http://traefik_traefik:80`
- All apps must join the `proxy` overlay network (external, already exists)

## Swarm Access

| Method | Details |
|--------|---------|
| SSH | `ssh <username>@<manager-ip>` (key-based auth; see vault for key and credentials) |
| Docker context | `docker context create swarm --docker "host=ssh://<username>@<manager-ip>"` |
| Portainer | See vault for URL |

Only key-based SSH access is available. Deploy commands run on any **manager node** (swarm-01, swarm-02, or swarm-03).

## Minimal Compose Template

```yaml
services:
  myapp:
    image: ghcr.io/paiindustries/myapp:latest
    environment:
      - PORT=8080
    networks:
      - proxy
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 1
        delay: 15s
        order: start-first
      labels:
        - traefik.enable=true
        - "traefik.http.routers.myapp.rule=Host(`myapp.example.com`)"
        - traefik.http.routers.myapp.entrypoints=web
        - traefik.http.services.myapp.loadbalancer.server.port=8080

networks:
  proxy:
    external: true
```

### Key points:
- **entrypoints=web** (port 80 only) — Cloudflare handles HTTPS, traffic arrives as HTTP
- **Do NOT set** `traefik.http.routers.myapp.tls=true` — there is no TLS internally
- **Do NOT use** `entrypoints=websecure` for cloudflared-proxied services
- Replace `myapp` in all label keys with your app's unique name (no conflicts with other services)
- Set `loadbalancer.server.port` to the port your app listens on inside the container

## Deploy Commands

> **Note:** Normal deployments go through GitHub Actions (see CI/CD section below). These commands are for manual debugging or initial setup only.

```bash
# From a manager node:
docker stack deploy -c docker-compose.yml myapp

# With private registry auth (GHCR, etc.):
docker login ghcr.io -u USERNAME -p TOKEN
docker stack deploy -c docker-compose.yml myapp --with-registry-auth

# Check status:
docker service ls
docker service ps myapp_myapp
docker service logs myapp_myapp --tail 50 -f

# Update after compose change:
docker stack deploy -c docker-compose.yml myapp

# Remove:
docker stack rm myapp
```

## CI/CD Deployment (GitHub Actions)

Normal deployments are automated via GitHub Actions — **do not deploy manually via SSH** unless debugging.

The standard pattern uses a **self-hosted runner on the swarm** (not SSH from a remote runner):

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # ... build and push image to GHCR ...

  deploy:
    runs-on: [self-hosted, Linux, swarm]
    needs: build
    steps:
      - uses: actions/checkout@v4

      - name: Login to GHCR
        run: echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GH_ACTOR" --password-stdin

      - name: Deploy stack
        run: docker stack deploy --with-registry-auth -c deploy/swarm/docker-compose.yml myapp
```

Self-hosted runners execute directly on the swarm manager, so `docker stack deploy` works without SSH tunneling. See `.github/workflows/swarm-deploy.yml` in each project for the full workflow.

## Private Registry (GHCR) Authentication

If using `ghcr.io` private images:

1. **All nodes must be able to pull the image**, OR use `--with-registry-auth` which distributes credentials from the deploying node to all nodes
2. If images fail with `No such image`, the auth didn't propagate — run `docker login ghcr.io` on each node, or redeploy with `--with-registry-auth`

## Shared Storage (CephFS Volumes)

All 4 nodes mount CephFS at `/mnt/cephfs`. For shared data across replicas:

### Create CephFS-backed volumes:

```bash
# 1. Create directory on CephFS
mkdir -p /mnt/cephfs/swarm/myapp/data

# 2. Create Docker volume pointing to it
docker volume create --driver local \
  --opt type=none \
  --opt o=bind \
  --opt device=/mnt/cephfs/swarm/myapp/data \
  myapp-data
```

### Use in compose:

```yaml
services:
  myapp:
    volumes:
      - myapp-data:/app/data

volumes:
  myapp-data:
    external: true
```

**Important:** Standard Docker volumes (`driver: local`) are node-local and NOT shared across replicas. Always use CephFS-backed volumes when replicas need shared data.

## CockroachDB Access

Applications can connect to the CockroachDB cluster via the VIP:

```
postgresql://username:password@<cockroachdb-vip>:26257/database?sslmode=disable
```

Database names, users, and passwords are stored in the vault. Contact the cluster admin for access.

To request a new database/user, ask the cluster admin.

### Session TTL

The `titan_sessiondb.cf_session_data` table has automatic row-level TTL — expired sessions are deleted hourly based on the `expires` column. No application-side cleanup needed.

## Cloudflare Tunnel Setup

The `cloudflared` service is already running on the swarm. To route a new hostname:

1. Go to **Cloudflare Zero Trust Dashboard > Networks > Tunnels**
2. Select the active tunnel
3. Add a **Public Hostname** entry:
   - **Hostname:** `myapp.example.com`
   - **Service:** `http://traefik_traefik:80`
   - **HTTP Host Header:** `myapp.example.com` (under Additional application settings > HTTP Settings)
4. Ensure DNS for `myapp.example.com` is proxied through Cloudflare (orange cloud)

The `httpHostHeader` is critical — it tells Traefik which service to route to.

## www Redirect Example

To redirect `www.example.com` to `example.com`:

```yaml
deploy:
  labels:
    - traefik.enable=true
    # Main router
    - "traefik.http.routers.myapp.rule=Host(`example.com`)"
    - traefik.http.routers.myapp.entrypoints=web
    - traefik.http.services.myapp.loadbalancer.server.port=8080
    # www redirect
    - "traefik.http.routers.myapp-www.rule=Host(`www.example.com`)"
    - traefik.http.routers.myapp-www.entrypoints=web
    - traefik.http.routers.myapp-www.middlewares=myapp-www-redirect
    - "traefik.http.middlewares.myapp-www-redirect.redirectregex.regex=^https?://www\\.example\\.com/(.*)"
    - "traefik.http.middlewares.myapp-www-redirect.redirectregex.replacement=https://example.com/$${1}"
    - traefik.http.middlewares.myapp-www-redirect.redirectregex.permanent=true
```

Add both `example.com` and `www.example.com` as public hostnames in the Cloudflare tunnel config.

## Sticky Sessions

For stateful apps (login sessions, websockets):

```yaml
deploy:
  labels:
    - traefik.http.services.myapp.loadbalancer.sticky.cookie=true
    - traefik.http.services.myapp.loadbalancer.sticky.cookie.name=myapp_affinity
    - traefik.http.services.myapp.loadbalancer.sticky.cookie.httponly=true
```

## Health Checks

Always include a health check so Swarm can detect unhealthy containers:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://127.0.0.1:8080/"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 60s
```

Set `start_period` high enough for your app to initialize (Lucee/Java apps may need 120s+).

## Resource Limits

Always set resource limits to prevent a single service from starving others:

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 2G
    reservations:
      cpus: '0.25'
      memory: 256M
```

**Note for JVM apps (Lucee, Tomcat, Spring):** The JVM defaults to a conservative heap size. Set `-Xmx` explicitly via environment variable or the container's JVM_OPTS to use the available memory. A 2G container limit with default 512MB heap will GC thrash under load. Use at least `-Xmx1536m` with a 2G limit, or increase the limit to 4G.

## Network Architecture

| Network | Type | Purpose |
|---------|------|---------|
| `proxy` | overlay, external | **Use this.** Connects services to Traefik |
| `monitoring` | overlay, external | Prometheus/Grafana/Loki internal |
| App-specific | overlay | Create for internal service-to-service communication |

Apps only need the `proxy` network for Traefik routing. If your stack has multiple services that talk to each other (e.g., app + redis), create a stack-internal network for that:

```yaml
services:
  app:
    networks:
      - proxy
      - internal
  redis:
    networks:
      - internal

networks:
  proxy:
    external: true
  internal:
    driver: overlay
```

## Swarm Nodes

Node hostnames, IPs, and roles are documented in the vault. The swarm consists of 3 manager nodes and 1 worker node with a Keepalived VIP.

Each node: 16 vCPU, 64GB RAM, 200GB disk, CephFS at `/mnt/cephfs`.

## Common Mistakes

1. **Using `entrypoints=websecure` with cloudflared** — cloudflared sends HTTP to port 80. Use `entrypoints=web`.
2. **Setting `tls=true` on routers** — Cloudflare handles TLS. Internal traffic is plain HTTP.
3. **Forgetting `--with-registry-auth`** — private images fail to pull on nodes where you haven't logged in.
4. **Local Docker volumes with multiple replicas** — data won't be shared. Use CephFS-backed volumes.
5. **Low memory limits for JVM apps** — Lucee/Tomcat need at least 2-4GB. Set `-Xmx` explicitly.
6. **Missing health check `start_period`** — Swarm kills slow-starting containers before they're ready.
7. **Duplicate Traefik router names** — every router/service/middleware name must be globally unique across all stacks.
8. **Forgetting the `proxy` network** — service won't be discoverable by Traefik without it.
9. **Compose `version` field quoting** — omit the `version` field entirely; modern Docker doesn't need it.

## Monitoring

| Tool | URL |
|------|-----|
| Portainer | See vault for URL |
| Grafana | See vault for URL and credentials |
| Prometheus | See vault for URL |
| Traefik Dashboard | `http://<manager-ip>:8080` |

Logs for any service: `docker service logs <service-name> --tail 100 -f`

All container logs are also shipped to Loki and queryable in Grafana.

## Quick Checklist for New App Deployment

- [ ] Compose file with `traefik.enable=true` labels
- [ ] `entrypoints=web` (NOT websecure)
- [ ] No `tls=true` on routers
- [ ] `loadbalancer.server.port` matches app's listen port
- [ ] Service on `proxy` network (external: true)
- [ ] Health check with appropriate `start_period`
- [ ] Resource limits set
- [ ] CephFS-backed volumes if replicas need shared data
- [ ] Cloudflare tunnel public hostname configured with `httpHostHeader`
- [ ] DNS proxied through Cloudflare (orange cloud)
- [ ] `--with-registry-auth` if using private images
