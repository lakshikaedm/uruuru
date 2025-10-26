class CartsController < ApplicationController
  def show
    @cart = cart_adapter
  end

  private

  def cart_adapter
    if user_signed_in?
      DbCart.new(current_user.cart || current_user.build_cart)
    else
      SessionCart.new(session)
    end
  end
end
