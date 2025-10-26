module Users
  class SessionsController < Devise::SessionsController
    after_action :merge_cart_after_login, only: :create

    def create
      super
    end

    private

    def merge_cart_after_login
      return unless current_user

      MergeSessionCart.new(session: session, user: current_user).call
    end
  end
end
