source "https://rubygems.org"

ruby "3.3.0"

# Core Rails & Server
gem "bootsnap", ">= 1.16.0", require: false
gem 'kaminari', '~> 1.2.2'
gem "pg", "~> 1.1"
gem "puma", ">= 7.0.3"
gem "rails", "~> 7.1.3"
gem "sprockets-rails"
gem "turbo-rails"

# Frontend / UI
gem "importmap-rails"
gem "jbuilder"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Authentication / Authorization
gem "devise", "~> 4.9"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-rails_csrf_protection"
gem "pundit"
gem "pundit-matchers"

# File Processing
gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.2"

# Models / Data Helpers
gem "ancestry", "~> 4.3"

# AI / Machine Learning
gem "openai", "~> 0.36.1"

# Payments
gem "stripe"

# Development Only
group :development do
  gem "letter_opener"
  gem "letter_opener_web"
  gem "rails-erd"
  gem "web-console"
end

# Test Only
group :test do
  gem "capybara"
  gem "faker", "~> 3.5"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.3"
  gem "webdrivers", "~> 5.2"
  gem "webmock", require: false
end

# Development & Test
group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem 'dotenv-rails'
  gem "factory_bot_rails", "~> 6.5"
  gem "rspec-rails", "~> 7.1"
  gem "rubocop", "~> 1.80"
  gem "rubocop-capybara", "~> 2.22"
  gem "rubocop-factory_bot", "~> 2.27"
  gem "rubocop-rails", "~> 2.33"
  gem "rubocop-rspec", "~> 3.7"
end

# OS-specific
gem "tzinfo-data", platforms: %i[windows jruby]
