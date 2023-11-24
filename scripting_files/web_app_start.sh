#!/usr/bin/env bash

echo "--- creating pids ---"
mkdir -p tmp/pids
echo "--- creating and migrating database ---"
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
echo "--- starting server ---"
bundle exec puma -C config/puma.rb
