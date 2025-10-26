class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    @cart.add(product.id, quantity_param || 1)

    redirect_to cart_path, notice: "#{product.title} added to cart."
  end

  def update
    product = Product.find(params[:product_id])
    @cart.update(product.id, quantity_param || 1)

    redirect_to cart_path, notice: "Updated #{product.title}."
  end

  def destroy
    product = Product.find(params[:product_id])
    @cart.remove(product.id)

    redirect_to cart_path, notice: "Removed #{product.title}."
  end

  private

  def set_cart
    @cart =
      if user_signed_in?
        DbCart.new(current_user.cart || current_user.create_cart!)
      else
        SessionCart.new(session)
      end
  end

  def quantity_param
    q = params.dig(:cart_item, :quantity) || params[:quantity]
    q.present? ? q.to_i : nil
  end
end
