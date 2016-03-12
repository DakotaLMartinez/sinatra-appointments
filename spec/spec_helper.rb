require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'
require 'database_cleaner'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

ENV["SINATRA_ENV"] = "test"

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods
  config.order = 'default'
  config.before(:all) do 
    DatabaseCleaner.start
  end
  config.append_after(:all) do 
    DatabaseCleaner.clean
  end
end

def session
  last_request.env['rack.session']
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app