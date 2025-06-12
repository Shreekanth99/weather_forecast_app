require 'rails_helper'

RSpec.describe ForecastController, type: :controller do
  describe "GET #index" do
    let(:address) { "Alipur, Andhra Pradesh" }
    let(:location) do
      {
        lat:  17.6936,
        lon:  83.2921,
        name: "Alipur"
      }
    end
    let(:forecast_data) do
      {
        location:    "Alipur",
        temperature: 30.5,
        condition:   "Clear sky",
        high:        32.0,
        low:         27.0
      }
    end

    context "when address is not provided" do
      it "renders index with an error" do
        get :index

        expect(response).to render_template(:index)
        expect(assigns(:error)).to eq("Please enter a valid address.")
      end
    end

    context "when location cannot be resolved" do
      before do
        allow(LocationResolverService).to receive(:new).and_return(double(call: nil))
      end

      it "renders index with an error" do
        get :index, params: { address: address }

        expect(response).to render_template(:index)
        expect(assigns(:error)).to eq("Could not determine coordinates from address.")
      end
    end

    context "when forecast is successfully fetched" do
      before do
        allow(LocationResolverService).to receive(:new).with(address).and_return(double(call: location))
        allow(ForecastCacheService).to receive(:new).with(location).and_return(double(call: [forecast_data, true]))
      end

      it "assigns forecast data and renders index" do
        get :index, params: { address: address }

        expect(response).to render_template(:index)
        expect(assigns(:forecast)).to eq(forecast_data)
        expect(assigns(:from_cache)).to eq(true)
        expect(assigns(:error)).to be_nil
      end
    end

    context "when forecast service fails" do
      before do
        allow(LocationResolverService).to receive(:new).and_return(double(call: location))
        allow(ForecastCacheService).to receive(:new).and_raise(StandardError.new("forecast error"))
      end

      it "logs error and renders index with nil forecast" do
        expect(Rails.logger).to receive(:error).with(/Forecast retrieval failed: forecast error/)

        get :index, params: { address: address }

        expect(response).to render_template(:index)
        expect(assigns(:forecast)).to be_nil
        expect(assigns(:from_cache)).to eq(false)
      end
    end

    context "when location resolver raises an error" do
      before do
        allow(LocationResolverService).to receive(:new).and_raise(StandardError.new("geocode failed"))
      end

      it "logs error and renders index with nil forecast" do
        expect(Rails.logger).to receive(:error).with(/Location resolution failed: geocode failed/)

        get :index, params: { address: address }

        expect(response).to render_template(:index)
        expect(assigns(:forecast)).to be_nil
        expect(assigns(:error)).to eq("Could not determine coordinates from address.")
      end
    end
  end
end
