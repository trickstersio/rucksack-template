#!/usr/bin/env ruby

require_relative "../config/runner"

runner = Runner.new
runner.run "bundle exec rake", ARGV.join(" ")
