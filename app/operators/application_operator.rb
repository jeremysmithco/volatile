class ApplicationOperator < ActiveOperator::Operator
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
