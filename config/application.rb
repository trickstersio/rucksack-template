class Application < Rucksack::Application
  def self.boot(router)
    ActiveRecord::Migration.check_pending!

    @application = Application.new
    @application.router = router
    @application.rack_app
  end

  def self.establish_database_connection!
    ActiveRecord::Base.establish_connection(
      adapter: Application.configuration.database.adapter,
      encoding: Application.configuration.database.encoding,
      pool: Application.configuration.database.pool,
      port: Application.configuration.database.port,
      username: Application.configuration.database.username,
      password: Application.configuration.database.password,
      host: Application.configuration.database.host,
      database: Application.configuration.database.database
    )
  end

  register_after_request_callback do
    ActiveRecord::Base.clear_active_connections!
  end
end

Application.configure(Configuration) do |configuration|
  configuration.app_name = ENV.fetch("APP_NAME")
  configuration.logger = Logger.new(STDOUT)
end

require_relative File.expand_path("environments/#{APP_ENV}", CONFIG_PATH)

ActiveRecord::Base.logger = Application.configuration.logger
Application.establish_database_connection!

Dir["#{CONFIG_PATH}/initializers/*.rb"].each do |initializer|
  require_relative initializer
end
