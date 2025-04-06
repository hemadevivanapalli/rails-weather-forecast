# spec/views/forecasts/_forecast.html.erb_spec.rb
require "rails_helper"

RSpec.describe "forecasts/_forecast.html.erb", type: :view do
  let(:day_data) do
    {
      "displayDate" => { "year" => 2025, "month" => 4, "day" => 6 },
      "maxTemperature" => { "degrees" => 28 },
      "minTemperature" => { "degrees" => 14 },
      "daytimeForecast" => {
        "weatherCondition" => { "description" => { "text" => "Sunny" }, "iconBaseUri" => "" },
        "precipitation" => { "probability" => { "percent" => 10 } }
      },
      "nighttimeForecast" => {
        "weatherCondition" => { "description" => { "text" => "Clear" } }
      }
    }
  end

  let(:forecast_data) { { "forecastDays" => [day_data] } }
  let(:address) { "Hyderabad" }

  before do
    allow(view).to receive(:forecast_day_summary).and_return({
      day_label: "SUN",
      short_date: "4/6",
      max_temp: 28,
      min_temp: 14,
      day_condition: "Sunny",
      night_condition: "Clear",
      precip: 10
    })
  end

  it "displays forecast title with address" do
    render partial: "forecasts/forecast", locals: { forecast_data: forecast_data, address: address }

    expect(rendered).to include("5-Day Forecast for #{address}")
    expect(rendered).not_to include("(pulled from cache)")
  end

  it "displays cache badge when @cached is true" do
    assign(:cached, true)

    render partial: "forecasts/forecast", locals: { forecast_data: forecast_data, address: address }

    expect(rendered).to include("(pulled from cache)")
  end

  it "renders forecast card with summary details" do
    render partial: "forecasts/forecast", locals: { forecast_data: forecast_data, address: address }

    expect(rendered).to include("SUN")
    expect(rendered).to include("4/6")
    expect(rendered).to include("28° /")
    expect(rendered).to include("14°")
    expect(rendered).to include("Sunny")
    expect(rendered).to include("Clear")
    expect(rendered).to include("💧 10%")
  end
end
