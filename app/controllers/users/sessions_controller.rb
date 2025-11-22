module Users
  class SessionsController < Devise::SessionsController
    after_action :merge_cart_after_login, only: :create

    def create
      super
    end

    def recruiter_demo
      recruiter_email = ENV.fetch("RECRUITER_DEMO_EMAIL", "recruiter@example.com")
      recruiter = User.find_by(email: recruiter_email)

      unless recruiter
        redirect_to new_user_session_path,
                    alert: t("devise.sessions.recruiter_demo_missing")
        return
      end

      sign_in(:user, recruiter)
      redirect_to root_path,
                  notice: t("devise.sessions.recruiter_demo_signed_in",
                            default: "Signed in as recruiter demo user.")
    end

    private

    def merge_cart_after_login
      return unless current_user

      MergeSessionCart.new(session: session, user: current_user).call
    end
  end
end
