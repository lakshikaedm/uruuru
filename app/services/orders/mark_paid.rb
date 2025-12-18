module Orders
  class MarkPaid
    class ProductAlreadySoldError < StandardError; end

    def initialize(order:)
      @order = order
    end

    def call
      return @order if @order.paid?

      Order.transaction do
        @order.lock!
        next @order if @order.paid?

        products = lock_products!
        ensure_products_not_sold!(products)

        @order.update!(status: :paid)
        products.each { |product| product.update!(status: :sold) }

        @order
      end
    end

    private

    def lock_products!
      products = @order.order_items.includes(:product).map(&:product).uniq
      products.each(&:lock!)
      products
    end

    def ensure_products_not_sold!(products)
      return unless products.any?(&:sold?)

      raise ProductAlreadySoldError,
            "One or more products are already sold for order ##{@order.id}"
    end
  end
end
