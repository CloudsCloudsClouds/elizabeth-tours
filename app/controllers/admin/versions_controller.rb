module Admin
  class VersionsController < Admin::ApplicationController
    before_action :set_version, only: :show

    def index
      @versions = PaperTrail::Version.order(created_at: :desc)
      @versions = @versions.where(item_type: params[:item_type]) if params[:item_type].present?
      @versions = @versions.where(event: params[:event]) if params[:event].present?

      page = (params[:page] || 1).to_i
      per_page = 30
      @total_count = @versions.count
      @versions = @versions.offset((page - 1) * per_page).limit(per_page)
      @page = page
      @per_page = per_page
    end

    def show
    end

    private

    def set_version
      @version = PaperTrail::Version.find(params[:id])
    end
  end
end
