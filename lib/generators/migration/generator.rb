module Generators
  module Migration
    class Generator < Generators::Base
      MIGRATION_TIMESTAMP_FORMAT = '%Y%m%d%H%M%S'.freeze

      class MigrationNameIsRequired < StandardError; end

      attr_reader :name

      def initialize(configuration, name: nil)
        super(configuration)

        raise MigrationNameIsRequired, 'Please, specify migration name' if name.nil?

        @name = name
      end

      protected def file_path
        File.expand_path(file_name, configuration.database_migrations_path)
      end

      protected def args
        {
          migration_class_name: migration_class_name
        }
      end

      private def timestamp
        Time.now.strftime(MIGRATION_TIMESTAMP_FORMAT)
      end

      private def file_name
        "#{timestamp}_#{name}.rb"
      end

      private def migration_class_name
        name.split("_").map(&:capitalize).join
      end
    end
  end
end
