require 'rails_helper'

RSpec.describe ForecastFetcherService do
  let(:address) { "Hyderabad" }
  let(:coordinates) { [17.4065, 78.4772] }
  let(:zip) { "10001" }
  let(:cache_key) { "forecast/#{zip}" }

  let(:forecast_data) do
    {
      "forecastDays" => [
        { "displayDate" => { "year" => 2025, "month" => 4, "day" => 6 } }
      ]
    }
  end

  before { Rails.cache.clear }

  describe "#call" do
    context "when cache hit" do
      it "returns cached forecast with cached flag true" do
        Rails.cache.write(cache_key, forecast_data)

        service = ForecastFetcherService.new(address)

        allow(service).to receive(:geocode_address_with_zip).and_return([[40.7128, -74.0060], "10001"])
        allow(service).to receive(:fetch_forecast).and_call_original # should not be called
        allow(service).to receive(:api_key).and_return("fake-key")

        result = service.call

        expect(result.success?).to be true
        expect(result.cached).to be true
        expect(result.forecast_data).to eq(forecast_data)
      end
    end

    context "when no cache and API success" do
      it "fetches from weather service and stores in cache" do
        service = ForecastFetcherService.new(address)

        allow(service).to receive(:geocode_address_with_zip).and_return([[40.7128, -74.0060], "10001"])
        allow(service).to receive(:fetch_forecast).and_return(forecast_data)
        allow(service).to receive(:api_key).and_return("fake-key")

        result = service.call

        expect(result.success?).to be true
        expect(result.cached).to be false
        expect(result.forecast_data).to eq(forecast_data)

        cached = Rails.cache.read(cache_key)
        expect(cached).to eq(forecast_data)
      end
    end

    context "when geocoding fails" do
      it "returns failure result" do
        service = ForecastFetcherService.new(address)

        allow(service).to receive(:geocode_address_with_zip).and_return([nil, nil])
        allow(service).to receive(:api_key).and_return("fake-key")

        result = service.call

        expect(result.failure?).to be true
        expect(result.error).to eq("Could not find location.")
      end
    end

    context "when weather API fails" do
      it "returns failure result" do
        service = ForecastFetcherService.new(address)

        allow(service).to receive(:geocode_address_with_zip).and_return([[40.7128, -74.0060], "10001"])
        allow(service).to receive(:fetch_forecast).and_return(nil)
        allow(service).to receive(:api_key).and_return("fake-key")

        result = service.call

        expect(result.failure?).to be true
        expect(result.error).to eq("Could not fetch forecast.")
      end
    end
  end
end
