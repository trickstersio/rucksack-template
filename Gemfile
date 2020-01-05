source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

gem "puma"
gem "jwt"
gem "pg"
gem "rake", "~> 12.3.2"
gem "bcrypt"
gem "activerecord", "~> 5.2.2", require: "active_record"
gem "activesupport", "~> 5.2.2", require: "active_support"
gem "rack-cors"
gem "zeitwerk"
gem "rucksack", github: "trickstersio/rucksack"
gem "faktory_worker_ruby"
gem "clockwork", require: false
gem "performify", "~> 1.0"

group :development, :test do
  gem "byebug"
  gem "rspec"
  gem "rubocop"
  gem "factory_bot"
  gem "rack-test"
  gem "ffaker"
  gem "webmock"
  gem "dotenv"
  gem "database_cleaner"
end

group :production do
  gem "tzinfo-data"
end
