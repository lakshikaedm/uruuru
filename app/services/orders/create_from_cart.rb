module Orders
  class CreateFromCart
    def initialize(user:, cart:, shipping_params:)
      @user = user
      @cart = cart
      @shipping = shipping_params
    end

    def call
      raise ArgumentError, "Cart is empty" if @cart.empty?

      Order.transaction do
        order = Order.new(user: @user, shipping_yen: 0, status: "pending")
        apply_shipping(order)
        add_items(order)
        order.recalculate_totals!
        order.save!
        @cart.clear
        order
      end
    end

    private

    def apply_shipping(order)
      order.assign_attributes(
        shipping_name: @shipping[:shipping_name],
        shipping_phone: @shipping[:shipping_phone],
        shipping_postal_code: @shipping[:shipping_postal_code],
        shipping_prefecture: @shipping[:shipping_prefecture],
        shipping_city: @shipping[:shipping_city],
        shipping_address1: @shipping[:shipping_address1],
        shipping_address2: @shipping[:shipping_address2].to_s
      )
    end

    def add_items(order)
      @cart.line_items.each do |line_item|
        product = line_item.product
        quantity = line_item.quantity
        order.order_items.build(
          product: product,
          unit_price_yen: product.price,
          quantity: quantity
        )
      end
    end
  end
end
