# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Wheels web application for the wheels.dev community website. Wheels is a CFML (ColdFusion Markup Language) framework with an MVC architecture similar to Ruby on Rails. The site includes features for blog management, user authentication, newsletter management, testimonials, and other community features.

## Technical Stack

- **Framework**: Wheels (CFML framework)
- **CLI Tools**: CommandBox for development workflow
- **Database Support**: MySQL, PostgreSQL, SQL Server, H2
- **CFML Engines**: Lucee 5/6, Adobe ColdFusion 2018/2021/2023
- **Dependencies**:
  - WireBox (for dependency injection)
  - TestBox (for testing)
  - LogBox (for logging)
- **Deployment**: Docker Swarm

## Project Structure

Following MVC architecture:
- `app/models/` - Model classes
- `app/controllers/` - Controller classes
- `app/views/` - View templates
- `app/config/` - Configuration files
- `app/migrator/migrations/` - Database migration files
- `tests/` - Test files
- `deploy/` - Environment-specific deployment configurations
- `.github/workflows/` - CI/CD pipeline configurations

## Development Commands

### Setting Up a Development Environment

1. Install CommandBox CLI
2. Install the wheels-cli CommandBox module:
```
box install wheels-cli
```

3. Start a new application (if needed):
```
box wheels new
```
or
```
box wheels generate app myApp
```

### Starting the Server

Start the CFML server:
```
box server start
```

### Database Migrations

View migrations status:
```
box wheels db info
```

Apply all pending migrations:
```
box wheels db latest
```

Create a new migration:
```
box wheels dbmigrate create table [name]
box wheels dbmigrate create column [name] [columnType] [columnName]
```

Reset database to initial state:
```
box wheels db reset
```

### Testing

Run application tests:
```
box wheels test app
```

Run core framework tests:
```
box wheels test core
```

Run plugin tests:
```
box wheels test [plugin-name]
```

### Reloading Application

Reload the application after code changes:
```
box wheels reload
```

### Code Formatting

Format code:
```
box run-script format
```

Check format without making changes:
```
box run-script format:check
```

### Docker Development

For complete testing environment with multiple engines and databases:

1. Ensure docker is installed
2. Increase Docker memory to about 4GB
3. Run from repository root:
```
docker compose up
```

Access test UI at: http://localhost:3000

Individual CFML engines available at:
- Lucee 5: localhost:60005
- Lucee 6: localhost:60006
- ACF 2018: localhost:62018
- ACF 2021: localhost:62021
- ACF 2023: localhost:62023

## Scaffolding Content

Create application components:
```
box wheels scaffold [objectName]
```

Generate specific components:
```
box wheels generate controller [name]
box wheels generate model [name]
box wheels generate view [name]
```

## Deployment Process

The application uses GitHub Actions for CI/CD to deploy to Docker Swarm environments. The deployment is configured for two environments:

### Production Deployment
- Triggered by pushes to the `main` branch
- Deploys to the production Docker Swarm with 3 replicas
- Uses configuration from `deploy/prod/`
- Exposed on port 50150

### Staging Deployment
- Triggered by pushes to the `develop` branch
- Deploys to the staging Docker Swarm with 3 replicas
- Uses configuration from `deploy/stage/`
- Exposed on port 50151

### Deployment Process
1. GitHub Actions workflow checks out the repository
2. Copies environment-specific files (docker-compose.yml, dockerfile, server.json)
3. Installs dependencies using CommandBox
4. Logs into private Docker registry
5. Builds and pushes Docker image to the registry
6. Deploys to Docker Swarm using `docker stack deploy`
7. Sends notification to Slack channel

### Shared Resources
Both environments use shared Docker volumes for persistent data:
- `shared-images` - For uploaded images
- `shared-files` - For uploaded files
- `wheels-data` - For application data

## Important Configuration Files

- `box.json` - Package dependencies and settings
- `CFConfig.json` - CFML engine configuration
- `app/config/settings.cfm` - Application settings including datasource config
- `app/config/routes.cfm` - URL routing configuration
- `deploy/*/docker-compose.yml` - Docker Swarm service configuration
- `deploy/*/dockerfile` - Docker image build configuration
- `deploy/*/server.json` - CommandBox server configuration
