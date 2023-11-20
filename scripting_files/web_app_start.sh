#!/usr/bin/env bash

echo "--- starting server ---"
mkdir -p tmp/pids
bundle exec puma -C config/puma.rb
