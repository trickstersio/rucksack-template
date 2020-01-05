#!/usr/bin/env ruby

require_relative "../config/runner"

runner = Runner.new
runner.run "irb -r /app/config/initialize.rb -r /app/config/application.rb"

