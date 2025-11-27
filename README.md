# wheels.dev

A community-driven web application built with Wheels 3.0, serving as the official website for the Wheels framework community. This application provides a platform for documentation, blogging, user engagement, and administrative management of the Wheels ecosystem.

## Features

- **Blog Management**: Create, edit, publish, and manage blog posts with categories, tags, and comments
- **User Authentication**: Complete user registration, login, password reset, and profile management
- **API Documentation**: Comprehensive API reference for Wheels framework functions and guides
- **Admin Dashboard**: Full administrative interface for content management, user moderation, and system settings
- **Newsletter System**: Subscriber management and email campaigns
- **Testimonials**: Community testimonials with approval workflow
- **Community Features**: Forums, news, and contributor management
- **Multi-environment Support**: Development, staging, production configurations
- **HTMX Integration**: Dynamic content loading without full page refreshes

## Architecture & Concepts

### Wheels MVC Framework

This application is built using **Wheels**, a Rails-inspired MVC (Model-View-Controller) framework for ColdFusion. Wheels emphasizes convention over configuration, providing a structured approach to web development.

#### Key Concepts:

**Models** (`app/models/`):
- Represent data entities and business logic
- Handle database interactions via ORM (Object-Relational Mapping)
- Examples: `Blog.cfc`, `User.cfc`, `Comment.cfc`
- Support for validations, associations, and callbacks

**Views** (`app/views/`):
- Handle presentation layer using CFML templates (.cfm files)
- Organized by controller and action (e.g., `web/HomeController/index.cfm`)
- Support for layouts, partials, and helpers

**Controllers** (`app/controllers/`):
- Manage application logic and request handling
- Process user input, interact with models, and render views
- Organized in namespaces: `web.*` (public), `admin.*` (admin), `api.*` (API)
- Examples: `AuthController.cfc`, `BlogController.cfc`

**Routes** (`config/routes.cfm`):
- Define URL patterns and map them to controller actions
- Use the `mapper()` DSL for clean route definitions
- Support for RESTful routes, namespaces, and wildcards
- Examples:
  ```cfscript
  .get(name="home", pattern="", to="web.HomeController##Index")
  .namespace("admin")
    .get(name="dashboard", pattern="/", to="AdminController##dashboard")
  .end()
  ```

**Configuration** (`config/`):
- `app.cfm`: Application-wide settings (datasources, sessions, caching)
- `settings.cfm`: Wheels-specific configuration (URL rewriting, migrations)
- Environment-specific overrides in `config/[environment]/`

**Migrations** (`app/migrator/migrations/`):
- Database schema management
- Version-controlled database changes
- Automatic migration on application start (configurable)

**Events** (`app/events/`):
- Application lifecycle hooks (onApplicationStart, onRequestStart, etc.)
- Global request processing and error handling

## Installation

### Prerequisites

- Lucee Server or Adobe ColdFusion
- CommandBox (for dependency management and server control)
- SQL Server (or compatible database via JDBC)

### Setup Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/wheels-dev/wheels.dev.git
   cd wheels.dev
   ```

2. **Install dependencies:**
   ```bash
   box install
   ```

3. **Configure environment variables:**
   - Copy `.env.example` to `.env` (if available)
   - Set database connection details, SMTP settings, and other environment-specific variables

4. **Start the development server:**
   ```bash
   box server start
   ```

5. **Access the application:**
   - Open `http://127.0.0.1:8080` in your browser
   - Admin interface: `http://127.0.0.1:8080/admin`

## Configuration

### Database Setup

The application uses SQL Server as the primary database. Configure the datasource in `config/app.cfm`:

```cfscript
this.datasources["wheels.dev"] = {
    class: "com.microsoft.sqlserver.jdbc.SQLServerDriver",
    bundleName: "org.lucee.mssql",
    bundleVersion: "#this.env.wheelsdev_bundleversion#",
    connectionString: "jdbc:sqlserver://#this.env.wheelsdev_host#:#this.env.wheelsdev_port#;DATABASENAME=#this.env.wheelsdev_databasename#;trustServerCertificate=true;SelectMethod=direct",
    username: "#this.env.wheelsdev_username#",
    password: "#this.env.wheelsdev_password#"
};
```

### Environment Variables

Key environment variables (set in `.env` or system environment):

- `wheelsdev_host`, `wheelsdev_port`, `wheelsdev_databasename`, `wheelsdev_username`, `wheelsdev_password`: Database connection
- `smtp_host`, `smtp_port`, `smtp_username`, `smtp_password`: Email configuration
- `sessionStorage`, `sessionCluster`: Session management
- `reloadPassword`: Application reload password

### Wheels Settings

Configure Wheels behavior in `config/settings.cfm`:

```cfscript
set(URLRewriting="On");           // Enable URL rewriting
set(autoMigrateDatabase=true);    // Auto-run database migrations
set(dataSourceName="wheels.dev"); // Default datasource
```

## Usage

### Key Routes & Endpoints

**Public Routes:**
- `/` - Homepage
- `/blog` - Blog listing and individual posts
- `/login`, `/register` - Authentication
- `/api/v1/blog` - API endpoints for blog data
- `/docs` - Documentation
- `/community` - Community section

**Admin Routes** (`/admin/`):
- `/admin/` - Dashboard
- `/admin/blog` - Blog management
- `/admin/user` - User management
- `/admin/settings` - System settings

### Development Workflow

1. **Code Formatting:**
   ```bash
   box run-script format
   ```

2. **Testing:**
   - Tests located in `tests/specs/`
   - Run with TestBox framework

3. **Database Migrations:**
   - Create new migrations in `app/migrator/migrations/`
   - Migrations run automatically on app start (if enabled)

4. **Deployment:**
   - Use deployment configurations in `deploy/`
   - Supports Docker and server-specific deployments

## Development & Contributing

### Code Style

- Follow Wheels conventions
- Use CommandBox for formatting: `box run-script format`
- Configuration in `.cfformat.json`

### Testing

- Unit and integration tests using TestBox
- Run tests: `box testbox run`
- Test files in `tests/specs/`

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Project Structure

```
wheels.dev/
├── app/
│   ├── controllers/     # Request handlers
│   ├── models/         # Data models
│   ├── views/          # Templates
│   ├── events/         # Application events
│   └── migrator/       # Database migrations
├── config/             # Configuration files
├── public/             # Static assets
├── tests/              # Test suite
├── docs/               # Documentation
└── deploy/             # Deployment configs
```

## Dependencies

- **Wheels Core**: MVC framework
- **WireBox**: Dependency injection
- **TestBox**: Testing framework
- **bcrypt**: Password hashing

See `box.json` for complete dependency list.

## License

Wheels is released under the Apache License Version 2.0.

## Support

- Documentation: https://wheels.dev/docs
- Community: https://wheels.dev/community
- Issues: https://github.com/wheels-dev/wheels.dev/issues
