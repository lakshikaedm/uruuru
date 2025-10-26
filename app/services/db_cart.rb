class DbCart
  Item = Struct.new(:product, :quantity, :line_total, keyword_init: true)

  def initialize(cart)
    @cart = cart
  end

  delegate :add, to: :@cart

  def update(product_id, quantity)
    @cart.update_item(product_id, quantity)
  end

  delegate :remove, to: :@cart

  def empty?
    @cart.cart_items.none?
  end

  def line_items
    # eager load products to avoid N+1
    items = @cart.cart_items.includes(:product)
    items.map do |item|
      product = item.product
      Item.new(
        product: product,
        quantity: item.quantity,
        line_total: product.price.to_d * item.quantity
      )
    end
  end

  def subtotal
    line_items.sum(&:line_total)
  end

  delegate :total_quantity, to: :@cart
end
