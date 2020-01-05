require "fileutils"

require_relative "config/initialize"

task :environment do
  require_relative "config/application"
end

Dir["tasks/*.rake"].each { |file| load file }
