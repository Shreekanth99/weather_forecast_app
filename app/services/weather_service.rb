# app/services/weather_service.rb
class WeatherService
  include HTTParty

  TIMEOUT_SECONDS = 5
  DEFAULT_UNITS   = 'metric'

  def initialize(lat:, lon:, units: DEFAULT_UNITS)
    @lat      = lat
    @lon      = lon
    @units    = units
    @api_key  = ENV.fetch('OPENWEATHER_API_KEY') { raise "Missing OPENWEATHER_API_KEY in environment" }
    @base_url = ENV.fetch('OPENWEATHER_API_URL') { raise "Missing OPENWEATHER_API_URL in environment" }
  end

  def call
    perform_request
  rescue HTTParty::Error, SocketError, Net::OpenTimeout => e
    Rails.logger.error("WeatherService error: #{e.message}")
    OpenStruct.new(success?: false, code: 503, body: nil)
  end

  private

  attr_reader :lat, :lon, :units, :api_key, :base_url

  def perform_request
    self.class.get(full_url, query: query_params, timeout: TIMEOUT_SECONDS)
  end

  def full_url
    "#{base_url}/weather"
  end

  def query_params
    {
      lat:   lat,
      lon:   lon,
      units: units,
      appid: api_key
    }
  end
end
