ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'webmock/rspec'
require 'devise'
require 'capybara/rspec'
require 'pundit/rspec'
require 'shoulda/matchers'

WebMock.disable_net_connect!(allow_localhost: true)

# Maintain test schema
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!

  # Devise helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::ControllerHelpers, type: :helper

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Capybara for system tests
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end

# Shoulda Matchers setup
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
