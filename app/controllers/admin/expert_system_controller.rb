module Admin
  class ExpertSystemController < Admin::ApplicationController
    def index
      return unless params[:gravity].present? && params[:fuel_severity].present?

      link = ENV["EXPT_LINK"]
      unless link
        @api_error = "EXPT_LINK environment variable not set"
        return
      end

      uri = URI("#{link}/evaluate")
      uri.query = URI.encode_www_form(
        gravity: params[:gravity],
        fuel_severity: params[:fuel_severity],
        description: params[:description].presence || "Sin descripción"
      )

      response = Net::HTTP.get_response(uri)
      @api_status = response.code
      @api_response = JSON.parse(response.body)
    rescue JSON::ParserError
      @api_error = "Invalid JSON response from API"
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError => e
      @api_error = "Could not connect to API: #{e.message}"
    rescue => e
      @api_error = e.message
    end
  end
end
