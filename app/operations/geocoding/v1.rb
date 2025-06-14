class Geocoding::V1 < ApplicationOperation
  def request
    faraday.get(
      "https://api.geocod.io/v1.8/geocode",
      { q: record.address, api_key: Rails.application.credentials.dig(:geocodio, :api_key), fields: "timezone" }
    )
  end

  def process
    result = response.dig("body", "results", 0)

    record.update!(
      latitude: result.dig("location", "lat"),
      longitude: result.dig("location", "lng"),
      timezone: result.dig("fields", "timezone", "name")
    )
  end
end
