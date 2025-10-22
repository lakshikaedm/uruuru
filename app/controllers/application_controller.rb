class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_cart

  private

  def user_not_authorized
    redirect_to(request.referer || root_path, alert: t('common.not_authorized'))
  end

  def current_cart
    @current_cart ||= Cart.new(session)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username avatar])
  end
end
