namespace :db do
  task migrate: :environment do
    migrations_paths = [ Application.configuration.database_migrations_path ]

    migration_context = ActiveRecord::MigrationContext.new(migrations_paths, ActiveRecord::Base.connection.schema_migration)
    migration_context.migrate

    Rake::Task["db:schema:dump"].invoke
  end

  task rollback: :environment do
    migrations_paths = [ Application.configuration.database_migrations_path ]

    migration_context = ActiveRecord::MigrationContext.new(migrations_paths, ActiveRecord::Base.connection.schema_migration)
    migration_context.rollback

    Rake::Task["db:schema:dump"].invoke
  end

  task seed: :environment do
    seed = Seed.new
    seed.execute!
  end

  namespace :schema do
    task dump: :environment do
      require 'active_record/schema_dumper'

      File.open(Application.configuration.database_schema_path, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

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
