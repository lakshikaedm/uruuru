class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_cart

  private

  def user_not_authorized
    redirect_to(request.referer || root_path, alert: t('common.not_authorized'))
  end

  def current_cart
    return @current_cart if defined?(@current_user)

    if user_signed_in?
      user_cart = current_user.cart || current_user.create_cart!
      @current_cart = DbCart.new(user_cart)
    else
      @current_cart = SessionCart.new(session)
    end
  end

  def set_locale
    locale = params[:locale] || session[:locale] || I18n.default_locale
    locale = locale.to_sym

    if I18n.available_locales.include?(locale)
      I18n.locale = locale
      session[:locale] = locale
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    { locale: (I18n.locale == I18n.default_locale ? nil : I18n.locale) }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username avatar])
  end
end
