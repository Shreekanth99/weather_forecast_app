class LocationResolverService
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def call
    result = search_location
    return unless valid_result?(result)

    format_location(result)
  rescue StandardError => e
    Rails.logger.error("Geocoding error: #{e.message}")
    nil
  end

  private

  def search_location
    Geocoder.search(address).first
  end

  def valid_result?(result)
    result&.latitude.present? && result&.longitude.present?
  end

  def format_location(result)
    {
      lat:  result.latitude,
      lon:  result.longitude,
      name: result.address || address
    }
  end
end
