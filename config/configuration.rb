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
