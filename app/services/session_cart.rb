class SessionCart
  SESSION_KEY = "cart".freeze

  def initialize(session)
    @session = session
    @data = session[SESSION_KEY] ||= {}
  end

  def add(product_id, quantity = 1)
    pid = product_id.to_s
    @data[pid] = (@data[pid] || 0) + quantity.to_i
    normalize!
  end

  def update(product_id, quantity)
    pid = product_id.to_s
    qty = quantity.to_i
    if qty <= 0
      @data.delete(pid)
    else
      @data[pid] = qty
    end
    normalize!
  end

  def remove(product_id)
    @data.delete(product_id.to_s)
    normalize!
  end

  def empty?
    @session[SESSION_KEY].values.map(&:to_i).sum.zero?
  end

  def clear
    @session[SESSION_KEY] = {}
  end

  CartItemVO = Struct.new(:product, :quantity, :line_total, keyword_init: true)

  def line_items
    products = Product.where(id: @data.keys.map(&:to_i)).index_by { |p| p.id.to_s }
    @data.map do |pid, qty|
      product = products[pid]
      next unless product

      CartItemVO.new(
        product: product,
        quantity: qty.to_i,
        line_total: product.price.to_d * qty.to_i
      )
    end.compact
  end

  def subtotal
    line_items.sum(&:line_total)
  end

  def total_quantity
    @data.values.map(&:to_i).sum
  end

  def raw_data
    @data.dup
  end

  private

  def normalize!
    @data.delete_if { |_pid, qty| qty.to_i <= 0 }
    @session[SESSION_KEY] = @data
  end
end
