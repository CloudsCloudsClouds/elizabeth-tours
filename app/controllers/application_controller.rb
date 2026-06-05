class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  around_action :switch_locale
  helper_method :logged_in?

  private

  def switch_locale(&action)
    if request.path.start_with?("/avo")
      yield
    else
      locale = params[:locale] || session[:locale] || I18n.default_locale
      locale = locale.to_sym if locale.respond_to?(:to_sym)
      locale = I18n.default_locale unless I18n.available_locales.include?(locale)
      session[:locale] = locale.to_s if params[:locale]
      I18n.with_locale(locale, &action)
    end
  end

  def logged_in?
    Current.session ||= Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    Current.session.present?
  end
end
