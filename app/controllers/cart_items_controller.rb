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
    @cart = Cart.new(session)
  end

  def quantity_param
    q = params.dig(:cart_item, :quantity)
    q.present? ? q.to_i : nil
  end
end
