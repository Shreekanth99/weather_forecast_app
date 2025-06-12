require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.configure_rspec_metadata!

  config.filter_sensitive_data('<OPENWEATHER_API_KEY>') { ENV['OPENWEATHER_API_KEY'] }
  config.filter_sensitive_data('<OPENWEATHER_API_URL>') { ENV['OPENWEATHER_API_URL'] }

  config.allow_http_connections_when_no_cassette = false
end
