threads_count = ENV.fetch("APP_MAX_THREADS") { 5 }
threads threads_count, threads_count

port ENV.fetch("APP_PORT") { 5000 }
environment ENV.fetch("APP_ENV") { "development" }

plugin :tmp_restart
