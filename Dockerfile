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

# Copy the entrypoint script
COPY bin/docker-entrypoint /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint

# Copy the rest of the application
COPY . /app/

# Set the entrypoint script
ENTRYPOINT ["docker-entrypoint"]

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
