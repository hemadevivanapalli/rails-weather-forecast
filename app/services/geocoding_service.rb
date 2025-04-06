# frozen_string_literal: true

# GeocodingService fetches coordinates and ZIP code from a given address.
# It performs two Google API requests: forward and reverse geocoding.
class GeocodingService
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/geocode'

  def initialize(api_key)
    @api_key = api_key
  end

  # Returns a hash with lat, lng and zip
  def fetch_coordinates_and_zip(address)
    location_response = self.class.get("/json", query: { address: address, key: @api_key })
    return nil unless location_response.success? && location_response.parsed_response['status'] == 'OK'

    location_result = location_response.parsed_response['results'].first
    lat = location_result['geometry']['location']['lat']
    lng = location_result['geometry']['location']['lng']

    reverse_response = self.class.get("/json", query: { latlng: "#{lat},#{lng}", key: @api_key })
    return nil unless reverse_response.success? && reverse_response.parsed_response['status'] == 'OK'

    zip = extract_zip_from_response(reverse_response.parsed_response['results'])
    return nil unless zip

    {
      lat: lat,
      lng: lng,
      zip: zip
    }
  rescue => e
    Rails.logger.error "Geocoding Error: #{e.message}"
    nil
  end

  private

  def extract_zip_from_response(results)
    results.each do |result|
      zip_component = result['address_components'].find do |comp|
        comp['types'].include?('postal_code')
      end
      return zip_component['short_name'] if zip_component
    end
    nil
  end
end
