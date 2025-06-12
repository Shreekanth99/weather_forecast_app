require 'rails_helper'

RSpec.describe ForecastCacheService do
  let(:location) do
    {
      lat:  17.6936,
      lon:  83.2921,
      name: "Alipur"
    }
  end

  let(:service) { described_class.new(location) }
  let(:cache_key) { "forecast:#{location[:lat]},#{location[:lon]}" }

  before { Rails.cache.clear }

  describe "#call" do
    context "when forecast data is already cached", :vcr do
      let(:cached_data) do
        {
          location:    "Alipur",
          temperature: 30.5,
          condition:   "clear sky",
          high:        32.0,
          low:         27.0
        }
      end

      before do
        Rails.cache.write(cache_key, cached_data, expires_in: 30.minutes)
      end

      it "returns the cached forecast and true" do
        result, from_cache = service.call
        
        expect(result).to eq(cached_data)
        expect(from_cache).to eq(true)
      end
    end

    context "when no cached data exists", :vcr do
      it "calls the weather API, stores result in cache, and returns it" do
        result, from_cache = service.call

        expect(result).to be_a(Hash)
        expect(result[:temperature]).to be_a(Numeric)
        expect(result[:condition]).to be_a(String)
        expect(result[:location]).to eq("Alipur")
        expect(from_cache).to eq(false)

        cached = Rails.cache.read(cache_key)
        expect(cached).to eq(result)
      end
    end

    context "when the API call fails" do
      before do
        allow_any_instance_of(WeatherService).to receive(:call).and_return(OpenStruct.new(success?: false))
      end

      it "returns nil and false" do
        result, from_cache = service.call

        expect(result).to be_nil
        expect(from_cache).to be_falsey
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(Rails.cache).to receive(:read).and_raise(StandardError.new("unexpected failure"))
      end

      it "logs the error and returns nil and false" do
        expect(Rails.logger).to receive(:error).with(/Weather fetch error: unexpected failure/)

        result, from_cache = service.call

        expect(result).to be_nil
        expect(from_cache).to be_falsey
      end
    end
  end
end
