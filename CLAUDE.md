# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the wheels.dev community website built with Wheels 3.0, a Rails-inspired CFML MVC framework. The site provides blog management, user authentication, API documentation, newsletter management, testimonials, and admin features.

## Development Commands

```bash
# Start development server
box server start

# Install dependencies
box install

# Code formatting
box run-script format           # Format all code
box run-script format:check     # Check formatting only

# Database migrations
box wheels db info              # View migration status
box wheels db latest            # Apply pending migrations

# Testing
box wheels test app             # Run application tests

# Reload application after changes
box wheels reload
```

## Architecture

### Controller Namespaces

Controllers are organized into three namespaces in `app/controllers/`:
- `web.*` - Public-facing controllers (HomeController, BlogController, AuthController, etc.)
- `admin.*` - Admin dashboard controllers (AdminController, UserController, NewsletterController, etc.)
- `api.*` - API endpoints

All controllers extend `app/controllers/Controller.cfc`, which provides:
- CSRF protection via `protectsFromForgery()`
- Authentication helpers: `isLoggedInUser()`, `isCurrentUserAdmin()`, `checkAdminAccess()`
- Role-based access control: `checkRoleAccess()`
- Shared business logic (e.g., `getBlogBySlug()`, `getTagsByBlogid()`)

### Model Patterns

Models in `app/models/` extend `app.Models.Model` and use:
- `table()` to specify database table name
- `property()` for column mappings with type coercion
- `belongsTo()`, `hasMany()` for associations
- Custom methods for business logic

Example from `Blog.cfc`:
```cfscript
table("blog_posts");
property(name="title", column="title", type="string");
belongsTo(name="User", foreignKey="createdBy");
hasMany(name="BlogCategory", foreignKey="blogId");
```

### Routing

Routes are defined in `config/routes.cfm` using the mapper DSL:
```cfscript
mapper()
    .namespace("api")
        .namespace("v1")
            .get(name="get_blog_posts", pattern="blog", to="api.BlogController##Index")
        .end()
    .end()
    .namespace("admin")
        .get(name="dashboard", pattern="/", to="AdminController##dashboard")
    .end()
    .wildcard()  // Enables automatic controller/action routing
.end();
```

### Views

Views in `app/views/` are organized by controller namespace:
- `app/views/web/` - Public views (HomeController/, BlogController/, etc.)
- `app/views/admin/` - Admin views
- `app/views/layout.cfm` - Main layout template
- `app/views/helpers.cfm` - View helper functions

### Configuration

- `config/app.cfm` - Application scope settings (datasources, sessions, mail servers)
- `config/settings.cfm` - Wheels framework settings (URL rewriting, auto-migration)
- `config/routes.cfm` - URL routing
- Environment overrides in `config/development/`, `config/production/`, etc.

### Environment Variables

Database and service configuration uses environment variables (set in `.env`):
- `wheelsdev_host`, `wheelsdev_port`, `wheelsdev_databasename`, `wheelsdev_username`, `wheelsdev_password` - SQL Server connection
- `smtp_host`, `smtp_port`, `smtp_username`, `smtp_password` - Email
- `reloadPassword` - Application reload password

## Deployment

The app runs on a **Docker Swarm cluster** (PAI Industries). Push to `main` triggers GitHub Actions:

1. **Build job** (ubuntu-latest): installs deps via CommandBox, builds Docker image (`ghcr.io/wheels-dev/wheels-dev`), pushes to GHCR
2. **Deploy job** (self-hosted swarm runner): runs `docker stack deploy` with the compose file at `deploy/swarm/docker-compose.yml`

Active deployment config lives in `deploy/swarm/`. See `deploy/swarm/DEPLOYMENT-GUIDE.md` for full Swarm cluster details.

> `deploy/prod/` and `deploy/stage/` are legacy (pre-Swarm systemd deployment) and kept for reference only.

## Key URLs

- `/` - Homepage
- `/blog` - Blog listing
- `/admin/` - Admin dashboard (requires authentication)
- `/api/v1/blog` - Blog API endpoint
- `/login`, `/register` - Authentication
