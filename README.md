# Geocoding App

A Ruby on Rails application for geocoding addresses and managing location data.

## Prerequisites

Before you begin, ensure you have the following installed on your system:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd geocoding_app
```

### 2. Environment Setup

1. Copy the example environment file:
```bash
cp .env.example .env
```

2. Open the `.env` file and configure your environment variables:
   - Add any required API keys
   - Modify any other settings as needed

### 3. Building and Starting the Application

1. Build the Docker images:
```bash
docker compose build
```

2. Start the application:
```bash
docker compose up
```

The application will be available at: http://localhost:3000

To run in detached mode (in the background):
```bash
docker compose up -d
```

### 4. Database Setup

The database will be automatically created and migrated when the application starts. However, if you need to run migrations manually:

```bash
docker compose exec web bundle exec rails db:create db:migrate
```

### 5. Stopping the Application

To stop the application:
```bash
docker compose down
```

To stop the application and remove all data (including the database):
```bash
docker compose down -v
```

## Development

### Running Rails Commands

To run Rails commands inside the Docker container:

```bash
docker compose exec web bundle exec rails console  # Rails console
docker compose exec web bundle exec rails routes   # List all routes
docker compose exec web bundle exec rails test     # Run tests
```

### Viewing Logs

To view application logs:
```bash
docker compose logs -f web  # Follow web application logs
docker compose logs -f db   # Follow database logs
```

### Rebuilding the Application

If you make changes to the Gemfile or Dockerfile:

```bash
docker compose build
docker compose up
```

## Troubleshooting

1. If the application fails to start:
   - Check if all required environment variables are set in `.env`
   - Ensure ports 3000 and 5432 are not in use by other applications
   - Try rebuilding the containers: `docker compose build`

2. If the database connection fails:
   - Wait a few moments as the database might still be initializing
   - Check the database logs: `docker compose logs db`
   - Ensure the database credentials in `.env` match those in `docker-compose.yml`

3. To reset the entire environment:
```bash
docker compose down -v
docker compose build
docker compose up
```

## Architecture

The application uses:
- Ruby 3.2
- Rails (latest version)
- PostgreSQL 13
- Docker for containerization

## Production Deployment

For production deployment:

1. Ensure all sensitive data is properly configured in environment variables
2. Use appropriate production settings in your `.env` file
3. Consider using a container orchestration platform like Kubernetes or Docker Swarm
4. Set up proper monitoring and logging solutions
5. Configure SSL/TLS for secure communication
