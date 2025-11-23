# syntax=docker/dockerfile:1
FROM ruby:3.4.6

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    postgresql-client \
    libpq-dev \
    nodejs \
    npm \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile assets (optional, can be done at runtime in development)
# RUN bundle exec rails assets:precompile

# Create tmp/pids directory for server PID files
RUN mkdir -p tmp/pids

# Make entrypoint script executable
RUN chmod +x bin/docker-entrypoint

# Expose port 3000
EXPOSE 3000
ENV PORT=3000

# Set entrypoint
ENTRYPOINT ["bin/docker-entrypoint"]

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
