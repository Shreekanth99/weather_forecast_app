require 'rails_helper'

RSpec.describe WeatherService do
  let(:lat) { 17.6936 }
  let(:lon) { 83.2921 }

  describe "#call" do
    context "when the request is successful", :vcr do
      let(:service) { described_class.new(lat: lat, lon: lon) }

      it "returns a successful HTTParty::Response with weather data" do
        response = service.call

        expect(response).to be_a(HTTParty::Response)
        expect(response.success?).to be true

        parsed = response.parsed_response
        expect(parsed).to be_a(Hash)
        expect(parsed.dig("main", "temp")).to be_a(Numeric)
        expect(parsed.dig("weather").first["description"]).to be_a(String)
      end
    end

    context "when the API key is invalid", :vcr do
      let(:service) do
        stub_const("ENV", ENV.to_hash.merge("OPENWEATHER_API_KEY" => "INVALID_KEY"))
        described_class.new(lat: lat, lon: lon)
      end

      it "returns a 401 Unauthorized response" do
        response = service.call

        expect(response).to be_a(HTTParty::Response)
        expect(response.code).to eq(401)
        expect(response.success?).to be false
        expect(response.parsed_response["message"]).to match(/invalid api key/i)
      end
    end
  end
end
