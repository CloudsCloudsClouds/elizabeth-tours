module Admin
  class ApplicationController < Administrate::ApplicationController
    include Authentication
    delegate :new_session_path, to: :main_app
    before_action :require_admin

    private

    def require_admin
      unless Current.user&.admin?
        flash[:alert] = "You must be an admin to access this page."
        redirect_to main_app.root_path
      end
    end

    # Override to skip resources without a corresponding dashboard (e.g. admin/expert_system)
    helper_method :dashboard_from_resource

    def dashboard_from_resource(resource_name)
      "#{resource_name.to_s.singularize}_dashboard".classify.constantize
    rescue NameError
      nil
    end
  end
end
