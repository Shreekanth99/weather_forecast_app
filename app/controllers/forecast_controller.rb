class ForecastController < ApplicationController
  def index
    @address = params[:address]

    return render_error("Please enter a valid address.") unless @address.present?

    location = resolve_location(@address)
    return render_error("Could not determine coordinates from address.") if location.blank?
    
    @forecast, @from_cache = fetch_forecast(location)
    render :index
  end

  private

  def resolve_location(address)
    LocationResolverService.new(address).call
  rescue => e
    Rails.logger.error("Location resolution failed: #{e.message}")
    nil
  end

  def fetch_forecast(location)
    ForecastCacheService.new(location).call
  rescue => e
    Rails.logger.error("Forecast retrieval failed: #{e.message}")
    [nil, false]
  end

  def render_error(message)
    @error = message
    render :index
  end
end
