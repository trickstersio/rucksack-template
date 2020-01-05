module Workers
  class ActiveRecordMiddleware
    def call(worker_instance, job)
      yield
    ensure
      ActiveRecord::Base.clear_active_connections!
    end
  end
end

Faktory.configure_worker do |config|
  config.worker_middleware do |chain|
    chain.add Workers::ActiveRecordMiddleware
  end

  config.default_job_options = {
    queue: Application.configuration.app_name
  }
end
