require 'rails_helper'

RSpec.describe LocationResolverService do
  let(:address) { "Alipur, Andhra Pradesh" }
  let(:service) { described_class.new(address) }

  describe "#call" do
    context "when a valid location is returned" do
      let(:geocoder_result) do
        double("Geocoder::Result",
          latitude: 17.6936,
          longitude: 83.2921,
          address: "Alipur, Andhra Pradesh, India"
        )
      end

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([geocoder_result])
      end

      it "returns formatted location data" do
        result = service.call

        expect(result).to eq(
          lat:  17.6936,
          lon:  83.2921,
          name: "Alipur, Andhra Pradesh, India"
        )
      end
    end

    context "when location is not found" do
      before do
        allow(Geocoder).to receive(:search).with(address).and_return([])
      end

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "when result does not have lat/lon" do
      let(:invalid_result) do
        double("Geocoder::Result",
          latitude: nil,
          longitude: nil,
          address: nil
        )
      end

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([invalid_result])
      end

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "when an exception occurs" do
      before do
        allow(Geocoder).to receive(:search).with(address).and_raise(StandardError.new("timeout"))
      end

      it "logs the error and returns nil" do
        expect(Rails.logger).to receive(:error).with(/Geocoding error: timeout/)
        expect(service.call).to be_nil
      end
    end
  end
end
