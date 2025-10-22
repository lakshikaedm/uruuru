class CartsController < ApplicationController
  def show
    @cart = Cart.new(session)
  end
end
