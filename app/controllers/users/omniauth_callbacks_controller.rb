module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      handle_auth("Facebook")
    end

    private

    def handle_auth(kind)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      else
        flash[:alert] = I18n.t("devise.omniauth_callbacks.failure", kind: kind)
        redirect_to new_user_registration_path, alert: "#{kind} login failed."
      end
    end
  end
end
