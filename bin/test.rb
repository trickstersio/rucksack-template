#!/usr/bin/env ruby

require_relative "../config/runner"

runner = Runner.new(app_env: "test")
runner.run "bundle exec rspec -r /app/spec/spec_helper.rb", ARGV.join(" ")
