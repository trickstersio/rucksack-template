#!/usr/bin/env ruby

require_relative "../config/runner"

cmd = ARGV.any? ? ARGV.join(" ") : "sh"

runner = Runner.new
runner.run cmd
