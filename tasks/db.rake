namespace :db do
  task seed: :environment do
    seed = Seed.new
    seed.execute!
  end

  namespace :schema do
    # Hey @kimrgrey, do we use this task?
    # I didn't find where `Application.configuration.db` comes from
    task load: :environment do
      begin
        should_reconnect = ActiveRecord::Base.connection_pool.active_connection?

        ActiveRecord::Schema.verbose = false
        ActiveRecord::Tasks::DatabaseTasks.load_schema Application.configuration.db, :ruby, Application.configuration.schema_path
      ensure
        if should_reconnect
          ActiveRecord::Base.establish_connection(Application.configuration.db)
        end
      end
    end
  end
end
