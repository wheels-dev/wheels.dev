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

## HTMX Error Handling Pattern

This app uses HTMX 2.0 for AJAX form submissions. A two-layer error handling pattern ensures errors are always visible to users and developers:

### Layer 1: Server-side (`public/Application.cfc` `onError`)

The `onError` method detects HTMX requests via the `HX-Request` header and returns JSON errors instead of HTML error pages:
- **Development mode**: Returns actual error message, detail, and type for debugging
- **Production mode**: Returns generic user-friendly message
- Always returns `500` status with `application/json` content type
- Uses `cfcontent(reset=true)` to clear any buffered output

### Layer 2: Client-side (`public/javascripts/global.js`)

Two global HTMX event listeners at the top of `global.js` act as safety nets:
- **`htmx:beforeSwap`**: Blocks full HTML error pages (`<!DOCTYPE`) from being swapped into the DOM. Extracts the `<title>` for a meaningful error notification.
- **`htmx:responseError`**: Catches 5xx responses, parses JSON error body from Layer 1, and shows notification with the error message. Logs detail to console in dev mode.

### Best Practices for HTMX Endpoints

1. **Always include `authenticityTokenField()`** in forms that use `hx-post`/`hx-put`/`hx-delete`. Missing CSRF tokens cause silent failures.
2. **JSON API views** (like `authenticate.cfm`) should set `request.wheels.showDebugInformation = false` to prevent the Wheels debug toolbar from corrupting JSON responses in development mode.
3. **Detect HTMX in controllers** using `structKeyExists(getHttpRequestData().headers, "HX-Request")` — see `Controller.cfc` `checkRoleAccess()` for an example of returning `HX-Redirect` headers.
4. **Use `renderWith()` with `layout='/responseLayout'`** for JSON API responses to avoid the full HTML layout wrapper.

## Key URLs

- `/` - Homepage
- `/blog` - Blog listing
- `/admin/` - Admin dashboard (requires authentication)
- `/api/v1/blog` - Blog API endpoint
- `/login`, `/register` - Authentication
