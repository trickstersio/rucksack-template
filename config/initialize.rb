require "bundler/setup"

require_relative "const"
require_relative "env"

APP_ENV = ENV.fetch("APP_ENV")

Bundler.require(:default, APP_ENV)

require "zeitwerk"

loader = Zeitwerk::Loader.new

loader.push_dir(APP_PATH)
loader.push_dir(LIB_PATH)
loader.push_dir(CONFIG_PATH)

if APP_ENV == "development"
  loader.enable_reloading
end

loader.setup
