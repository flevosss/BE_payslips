#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Starting Rails server..."
bundle exec puma -C config/puma.rb

