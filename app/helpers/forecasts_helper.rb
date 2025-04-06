# frozen_string_literal: true

module ForecastsHelper
  # Prepares a summary hash for a given day's forecast
  def forecast_day_summary(day)
    date = Date.new(
      day["displayDate"]["year"],
      day["displayDate"]["month"],
      day["displayDate"]["day"]
    )

    daytime   = day["daytimeForecast"] || {}
    nighttime = day["nighttimeForecast"] || {}

    {
      day_label: date.strftime("%A")[0..2].upcase,
      short_date: date.strftime("%-m/%-d"),
      max_temp: day.dig("maxTemperature", "degrees").to_i,
      min_temp: day.dig("minTemperature", "degrees").to_i,
      day_condition: daytime.dig("weatherCondition", "description", "text") || "N/A",
      night_condition: nighttime.dig("weatherCondition", "description", "text") || "N/A",
      precip: daytime.dig("precipitation", "probability", "percent") || 0,
      icon: daytime.dig("weatherCondition", "iconBaseUri")
    }
  end
end
