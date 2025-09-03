# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Hypo**, a multi-tenant Rails 8.0 application with a sophisticated architecture supporting different subdomains and user roles. The app handles hypothesis tracking and project management with Telegram integration, background job processing, and real-time features via Action Cable.

## Key Architecture Components

### Multi-tenancy Structure
- **Main application** (`www` subdomain): Redirects to home URL
- **Home subdomain**: User authentication, profiles, accounts management
- **Admin subdomain**: Administrative interface using Administrate gem
- **Tenant subdomains**: Project-specific workspaces with isolated data

### Database Architecture
- Uses PostgreSQL with multiple database URLs (PRIMARY_DATABASE_URL, TENANT_DATABASE_URL)
- Database setup via `bin/setup` script or manual recreation with `make recreate-db`

### Key Technology Stack
- Rails 8.0 with Propshaft asset pipeline
- Stimulus.js + Turbo for frontend
- PostgreSQL with Solid Cache/Queue/Cable for persistence
- Telegram Bot integration (`telegram-bot` gem)
- Bootstrap 5 with Sass compilation
- Slim templates
- Background jobs with Solid Queue
- Metrics with Yabeda + Prometheus

### Authentication & Authorization
- Sorcery gem for authentication
- Email-based login with verification codes
- Telegram OAuth integration
- Admin access controlled via `AdminConstraint`
- Account-level access via `AccountConstraint`

## Development Commands

### Basic Development
```bash
# Start Rails server
dip rails s

# Run full test suite
dip rails test
dip rails test:system

# Run single test file
dip rails test test/models/account_test.rb

# Access Rails console
dip rails c

# Access database console
dip psql
```

### Asset Compilation
```bash
# Build CSS from Sass
yarn build:css

# Watch for CSS changes during development  
yarn watch:css

# Build CSS with compilation and prefixing
yarn build:css:compile && yarn build:css:prefix
```

### Code Quality & Security
```bash
# Lint Ruby code (follows Rails Omakase style)
bin/rubocop -f github

# Security scanning
bin/brakeman --no-pager
bin/importmap audit

# Run all CI checks locally
bin/rubocop -f github && bin/brakeman --no-pager && bin/rails test test:system
```

### Database Operations
```bash
# Setup/reset database
bin/setup

# Recreate development database (via Makefile)
make recreate-db

# Run migrations
bin/rails db:migrate
```

### Docker Development (via Dip)
```bash
# Provision development environment
dip provision

# Access container shell with dependencies
dip runner

# Run commands in container
dip bash
dip bundle install
dip yarn install
```

### Deployment & Release
```bash
# Create patch release with deployment
make patch

# Create minor release with deployment  
make minor

# Manual release creation
make bump-patch && make push-release
```

## Important File Locations

### Core Configuration
- `config/application.rb` - Main app configuration with multi-tenancy setup
- `config/routes.rb` - Subdomain-based routing with constraints
- `dip.yml` - Docker development environment configuration
- `Makefile` - Release and deployment automation

### Models & Business Logic
- `app/models/account.rb` - Tenant account model
- `app/models/user.rb` - User authentication model  
- `app/models/hypothesis.rb` - Core business entity
- `app/controllers/concerns/` - Shared controller behaviors (authentication, pagination, ransack)

### Background Processing
- `app/jobs/` - Solid Queue background jobs
- `config/queue.yml` - Queue configuration
- `config/recurring.yml` - Recurring job schedules

### Frontend Assets
- `app/assets/stylesheets/` - Sass stylesheets with Bootstrap
- `app/javascript/` - Stimulus controllers and channels
- `config/importmap.rb` - JavaScript module imports

## Testing Strategy

The app uses Rails' built-in testing framework with:
- Unit tests in `test/models/`
- Controller tests in `test/controllers/` 
- System tests with Capybara + Selenium
- Fixtures in `test/fixtures/`
- Test helper with common setup in `test/test_helper.rb`

Run system tests specifically with: `bin/rails test:system`

## Multi-tenancy Considerations

When working with tenant-specific features:
- Code in `app/controllers/tenant/` operates within account context
- Use `Current.account` to access the current tenant context
- Routes under `tenant` scope are constrained by `AccountConstraint`
- Models may need account scoping for proper data isolation

## Styling & UI

- Uses Bootstrap 5 with custom Sass extensions
- Icons via `bootstrap-icons-helper` gem
- Responsive design with mobile-first approach
- Slim templates for clean, semantic markup
- Real-time UI updates via Action Cable channels
