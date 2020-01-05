namespace :generate do
  task migration: :environment do
    generator = Generators::Migration::Generator.new(Application.configuration, name: ARGV[1])
    generator.generate!

    exit(0)
  end
end
