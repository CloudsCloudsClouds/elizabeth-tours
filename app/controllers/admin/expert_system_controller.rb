require "net/http"
require "uri"
require "json"

module Admin
  class ExpertSystemController < ApplicationController
    include Authentication

    before_action :require_authentication
    before_action :require_admin

    def index
      if params[:gravity].present?
        expt_link = ENV["EXPT_LINK"]
        unless expt_link.present?
          @api_error = "EXPT_LINK no está configurado. Asegúrate de ejecutar el servidor con `mise exec -- bin/rails server`."
          @api_status = 0
          return
        end

        uri = URI("#{expt_link}evaluate")
        uri.query = URI.encode_www_form(
          gravity: params[:gravity],
          description: params[:description]
        )

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = 5
        http.read_timeout = 10

        request = Net::HTTP::Get.new(uri)

        begin
          response = http.request(request)
          @api_response = response.body
          @api_status = response.code.to_i
        rescue StandardError => e
          @api_error = e.message
          @api_status = 0
        end
      end
    end

    private

    def require_admin
      unless Current.user&.admin?
        redirect_to main_app.root_path, alert: "No tienes permisos para acceder a esta página."
      end
    end
  end
end
