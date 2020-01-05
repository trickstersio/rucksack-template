class Configuration < Rucksack::Configuration
  attr_accessor :app_name
  attr_accessor :database
  attr_accessor :public_url
  attr_accessor :port
  attr_accessor :session_secret

  def initialize
    super

    @port = ENV.fetch("APP_PORT")
    @database = init_database_configuration
  end

  def database_migrations_path
    relative_to_root('db/migrations')
  end

  def database_schema_path
    relative_to_root('db/schema.rb')
  end

  private def relative_to_root(path)
    Pathname.new(File.expand_path(path, ROOT_PATH))
  end

  private def init_database_configuration
    OpenStruct.new(
      adapter: "postgresql",
      encoding: "unicode",
      pool: 5,
      username: nil,
      password: nil,
      host: nil,
      port: 5432,
      database: nil
    )
  end
end
