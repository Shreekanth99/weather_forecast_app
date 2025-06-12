class ForecastCacheService
  def initialize(location)
    @location = location
    @lat      = location[:lat]
    @lon      = location[:lon]
    @name     = location[:name]
  end

  def call
    return [cached_forecast, true] if cached_forecast.present?

    fetch_and_cache_forecast
  rescue => e
    Rails.logger.error("Weather fetch error: #{e.message}")
    [nil, false]
  end

  private

  attr_reader :location, :lat, :lon, :name

  def cache_key
    "forecast:#{lat},#{lon}"
  end

  def cached_forecast
    @cached_forecast ||= Rails.cache.read(cache_key)
  end

  def fetch_and_cache_forecast
    
    response = WeatherService.new(lat: lat, lon: lon).call
    return [nil, false] unless response.success?

    parsed = parse_response(response)
    Rails.cache.write(cache_key, parsed, expires_in: 30.minutes)
    [parsed, false]
  end

  def parse_response(response)
    main     = response['main'] || {}
    weather  = response['weather']&.first || {}

    {
      location:    name,
      temperature: main['temp'],
      condition:   weather['description'],
      high:        main['temp_max'],
      low:         main['temp_min']
    }
  end
end
