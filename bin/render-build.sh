#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Build Tailwind CSS
bundle exec rails tailwindcss:build

# Precompile assets
bundle exec rails assets:precompile

# Run database migrations
bundle exec rails db:migrate

# Seed the database (optional - remove if you don't want to seed in production)
# bundle exec rails db:seed

