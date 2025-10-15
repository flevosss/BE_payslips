#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Preparing database (runs all migrations)..."
bundle exec rails db:prepare

echo "Seeding database..."
bundle exec rails db:seed

echo "Starting Rails server..."
bundle exec puma -C config/puma.rb

