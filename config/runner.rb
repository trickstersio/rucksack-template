require "digest"

require_relative "const"
require_relative "env"

class Runner
  class ExecutionFailed < RuntimeError; end

  APP_ENV = ENV.fetch("APP_ENV")
  APP_NAME = ENV.fetch("APP_NAME")

  attr_reader :app_env
  attr_reader :app_name

  def initialize(app_env: APP_ENV, app_name: APP_NAME)
    @app_env = app_env
    @app_name = app_name
    @ready_to_run = false
  end

  def up
    if !ready_to_run?
      prepare_runner
    end

    local "docker-compose", docker_compose_args, "up", "--detach", "api"
  end

  def down
    local "rm -rf #{cache_dir_path}"
    local "docker-compose", docker_compose_args, "down", "--volumes", "--remove-orphans", "--rmi local"
  end

  def run(*cmd)
    if !ready_to_run?
      prepare_runner
    end

    remote(*cmd)
  end

  private def ready_to_run?
    @ready_to_run
  end

  private def prepare_runner
    local "mkdir -p #{cache_dir_path}"
    local "docker-compose", docker_compose_args, "up", "--detach", "runner"

    cache gemfile_lock_cache_key do
      remote "bundle install"
    end

    cache migrations_cache_key do
      remote "bundle exec rake db:migrate"
    end

    @ready_to_run = true
  end

  private def cache(key)
    path = "#{cache_dir_path}/#{key}"

    if File.exists?(path)
      return
    end

    yield if block_given?

    FileUtils.touch(path)
  end

  private def cache_dir_path
    @cache_dir_path ||= "#{TMP_PATH}/runner/#{app_name}/#{app_env}"
  end

  private def migrations_cache_key
    @migrations_cache_key ||= digest do
      Dir["#{ROOT_PATH}/db/migrations/*.rb"].sort.map { |filename| digest { File.basename(filename, ".rb") } }.join
    end
  end

  private def gemfile_lock_cache_key
    @gemfile_lock_cache_key ||= digest { File.read(gemfile_lock_path) }
  end

  private def digest
    Digest::SHA256.hexdigest(yield)
  end

  private def remote(*cmd)
    local "docker-compose", docker_compose_args, "exec", docker_compose_exec_args, "runner", *cmd
  end

  private def docker_compose_exec_args
    args = []
    args << "-T" if ci?
    args.join(" ")
  end

  private def ci?
    ENV["GITHUB_ACTIONS"] == "true"
  end

  private def local(*args)
    cmd = args.map do |arg|
      case arg
      when Hash
        arg.map { |k, v| "#{k.to_s} #{v.to_s}" }.join(" ")
      else
        arg.to_s
      end
    end.join(" ")

    puts "Running #{cmd}"

    system(ENV, cmd) || (raise ExecutionFailed, "Failed to execute: #{cmd}")
  end

  private def docker_compose_args
    {
      "--project-name" => "#{app_name}_#{app_env}",
      "--project-directory" => ROOT_PATH,
      "--file" => docker_compose_config_path,
    }
  end

  private def gemfile_lock_path
    @gemfile_lock_path ||= Pathname.new(File.expand_path("Gemfile.lock", ROOT_PATH))
  end

  private def docker_compose_config_path
    @docker_compose_config_path ||= Pathname.new(File.expand_path("docker/docker-compose.yml", CONFIG_PATH))
  end
end


