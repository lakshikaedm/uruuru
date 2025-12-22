class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, only: %i[new create]

  def index
    redirect_to new_order_path
  end

  def show
    @order = current_user.orders.includes(order_items: :product).find(params[:id])
  end

  def new
    @order = Order.new
  end

  def edit
    @order = current_user.orders.find(params[:id])
  end

  def create
    pref = params.dig(:order, :shipping_prefecture)
    shipping_yen = pref.present? ? ShippingCalculator.new.call(prefecture: pref) : nil

    shipping_params = order_params.to_h.symbolize_keys
    shipping_params[:shipping_yen] = shipping_yen if shipping_yen

    @order = Orders::CreateFromCart.new(
      user: current_user,
      cart: current_cart,
      shipping_params: shipping_params
    ).call

    redirect_to order_path(@order)
  rescue ActiveRecord::RecordInvalid => e
    @order = e.record
    render :new, status: :unprocessable_entity
  rescue ArgumentError => e
    @order ||= Order.new(order_params)
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def pay
    @order = current_user.orders.find(params[:id])
    checkout_session = create_stripe_checkout_session(@order)
    redirect_to checkout_session.url, allow_other_host: true
  end

  def success
    @order = current_user.orders.find(params[:id])
    @order.update!(status: :paid) if @order.respond_to?(:status)
    current_cart.clear if current_cart.respond_to?(:clear)
    OrderMailer.with(locale: I18n.locale).confirmation(@order).deliver_later
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    @order.update!(status: :cancelled) if @order.respond_to?(:status)
    redirect_to cart_path, alert: t("orders.payment_cancelled", default: "Payment was cancelled.")
  end

  def update
    @order = current_user.orders.find(params[:id])

    if @order.update(order_params)
      redirect_to order_path(@order), notice: t('.notice')
    else
      render :edit, status: :unprocessable_content
    end
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

  def current_cart
    return @current_cart if defined?(@current_cart)

    if user_signed_in?
      user_cart = current_user.cart || current_user.create_cart!
      @current_cart = DbCart.new(user_cart)
    else
      @current_cart = SessionCart.new(session)
    end
  end

  def create_stripe_checkout_session(order)
    Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",
      client_reference_id: order.id.to_s,
      metadata: { order_id: order.id.to_s },
      line_items: [
        {
          price_data: {
            currency: "jpy",
            unit_amount: order.total_yen,
            product_data: {
              name: "Uruuru Order ##{order.id}"
            }
          },
          quantity: 1
        }
      ],
      success_url: success_order_url(order),
      cancel_url: cancel_order_url(order)
    )
  end
end
