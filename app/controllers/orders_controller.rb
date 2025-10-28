class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, only: %i[new create]

  def show
    @order = current_user.orders.includes(order_items: :product).find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    order = Order::CreateFromCart.new(
      user: current_user,
      cart: current_cart,
      shipping_params: order_params
    ).call

    redirect_to order_path(order), notice: t(".success")
  rescue ActiveRecord::RecordInvalid, ArgumentError => e
    @order = Order.new(order_params)
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(
      :shipping_name, :shipping_phone, :shipping_postal_code,
      :shipping_prefecture, :shipping_city, :shipping_address1, :shipping_address2
    )
  end

  def ensure_cart_not_empty
    return unless current_cart.empty?

    redirect_to cart_path, alert: t(".empty")
  end
end
