require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "GET /forecasts/new" do
    it "renders the new template" do
      get new_forecast_path
      expect(response).to render_template(:new)
    end
  end

  describe "POST /forecasts" do
    let(:valid_address) { "Hyderabad" }

    context "when address is blank" do
      it "renders new with error message" do
        post forecasts_path, params: { address: "" }
        expect(response.body).to include("Please enter an address.")
        expect(response).to render_template(:new)
      end
    end

    context "when service returns failure" do
      it "renders new with service error message" do
        allow(ForecastFetcherService).to receive(:call).and_return(
          ForecastFetcherService::Result.new(nil, "Could not find location.", false)
        )

        post forecasts_path, params: { address: "Invalid Location" }
        expect(response.body).to include("Could not find location.")
        expect(response).to render_template(:new)
      end
    end

    context "when service returns success" do
      it "renders new with forecast data" do
        forecast_data = {
          "forecastDays" => [
            {
              "displayDate" => { "year" => 2025, "month" => 4, "day" => 6 },
              "maxTemperature" => { "degrees" => 24 },
              "minTemperature" => { "degrees" => 12 },
              "daytimeForecast" => {
                "weatherCondition" => { "description" => { "text" => "Cloudy" }, "iconBaseUri" => "" },
                "precipitation" => { "probability" => { "percent" => 10 } }
              },
              "nighttimeForecast" => {
                "weatherCondition" => { "description" => { "text" => "Clear" } }
              }
            }
          ]
        }

        allow(ForecastFetcherService).to receive(:call).and_return(
          ForecastFetcherService::Result.new(forecast_data, nil, false)
        )

        post forecasts_path, params: { address: valid_address }
        expect(response.body).to include("5-Day Forecast for #{valid_address}")
        expect(response).to render_template(:new)
      end
    end
  end
end
