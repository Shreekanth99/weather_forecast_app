source "https://rubygems.org"

ruby "3.2.0"

# Core Rails version
gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# Database
gem "sqlite3", ">= 1.4"

# Server & performance
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "bootsnap", require: false

# API rendering
gem "jbuilder"

# HTTP requests for external APIs
gem "httparty"

# Geocoding (address to ZIP)
gem "geocoder"

# Redis for caching
gem "redis"

# Load .env variables
gem "dotenv-rails", groups: [:development, :test]

# Interactive debugging
gem "pry"

# Testing framework
gem "rspec-rails", group: [:development, :test]

# Debugging tools
group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  # Optional: Add for mocking HTTP requests in specs
  gem "webmock"
  gem "vcr"
  gem "rails-controller-testing"
end

# Timezone data for Windows platforms
gem "tzinfo-data", platforms: %i[windows jruby]
