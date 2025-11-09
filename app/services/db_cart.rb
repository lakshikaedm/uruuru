class DbCart
  Item = Struct.new(:product, :quantity, :line_total, keyword_init: true)

  def initialize(cart)
    @cart = cart
  end

  delegate :total_quantity, to: :@cart

  def empty?
    @cart.cart_items.none?
  end

  def line_items
    @cart.cart_items.includes(:product).map do |ci|
      product = ci.product
      qty     = ci.quantity.to_i
      Item.new(
        product: product,
        quantity: qty,
        line_total: product.price.to_i * qty
      )
    end
  end

  def subtotal
    line_items.sum(&:line_total)
  end

  def add(product_id, qty = 1)
    item = @cart.cart_items.find_or_initialize_by(product_id: product_id)
    base = item.persisted? ? item.quantity.to_i : 0
    item.quantity = base + qty.to_i
    item.save!
  end

  def update(product_id, qty)
    item = @cart.cart_items.find_by(product_id: product_id)
    return unless item

    q = qty.to_i
    if q <= 0
      item.destroy!
    else
      item.update!(quantity: q)
    end
  end

  def remove(product_id)
    @cart.cart_items.where(product_id: product_id).delete_all
  end

  def clear
    @cart.cart_items.delete_all
  end
end
