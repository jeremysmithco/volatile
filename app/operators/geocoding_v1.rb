class GeocodingV1 < ApplicationOperator
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

  private

  def faraday
    @faraday ||= begin
      Faraday.new(request: { open_timeout: 1, read_timeout: 1, write_timeout: 1 }) do |config|
        config.request :json
        config.response :json
        config.response :raise_error

        if Rails.env.local?
          config.response :logger, Rails.logger, headers: true, bodies: true, log_level: :debug
        end
      end
    end
  end
end
