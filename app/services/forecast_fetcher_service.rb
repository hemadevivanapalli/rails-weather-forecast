# frozen_string_literal: true

# ForecastFetcherService is responsible for orchestrating the geocoding and weather fetching
# process, including 30-minute caching based on ZIP code.
class ForecastFetcherService
  # Struct to encapsulate result details
  Result = Struct.new(:forecast_data, :error, :cached) do
    def success? = forecast_data.present?
    def failure? = !success?
  end

  def self.call(address)
    new(address).call
  end

  def initialize(address)
    @address = address
  end

  def call
    coordinates, zip = geocode_address_with_zip
    return Result.new(nil, "Could not find location.") unless coordinates && zip

    cache_key = "forecast/#{zip}"
    cached_data = Rails.cache.read(cache_key)

    if cached_data
      return Result.new(cached_data, nil, true)
    end

    forecast_data = fetch_forecast(coordinates)
    return Result.new(nil, "Could not fetch forecast.") unless forecast_data

    Rails.cache.write(cache_key, forecast_data, expires_in: 30.minutes)
    Result.new(forecast_data, nil, false)
  end

  private

  def geocode_address_with_zip
    data = GeocodingService.new(api_key).fetch_coordinates_and_zip(@address)
    return [nil, nil] unless data

    [[data[:lat], data[:lng]], data[:zip]]
  end

  def fetch_forecast(coordinates)
    lat, lng = coordinates
    WeatherService.new(api_key).fetch_weekly_forecast(lat, lng)
  end

  def api_key
    ENV['GOOGLE_API_KEY']
  end
end
