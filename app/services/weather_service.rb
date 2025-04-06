# frozen_string_literal: true

# WeatherService fetches a 7-day weather forecast using the Google Weather API.
class WeatherService
  include HTTParty
  base_uri 'https://weather.googleapis.com/v1'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_weekly_forecast(lat, lon)
    response = self.class.get("/forecast/days:lookup", query: {
      key: @api_key,
      'location.latitude': lat,
      'location.longitude': lon,
      days: 5
    })

    response.success? ? response.parsed_response : nil
  rescue => e
    Rails.logger.error "Weather Fetch Error: #{e.message}"
    nil
  end
end
