FROM ruby:3.2

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client netcat-traditional && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile* /app/
RUN bundle install

# Copy the rest of the application
COPY . /app/

# Start the main process
CMD bash -c "rm -f /app/tmp/pids/server.pid && \
    until nc -z -v -w30 db 5432; do \
        echo 'Waiting for PostgreSQL...' && \
        sleep 1; \
    done && \
    echo 'PostgreSQL is up and running!' && \
    bundle exec rails db:prepare && \
    bundle exec rails server -b 0.0.0.0"
