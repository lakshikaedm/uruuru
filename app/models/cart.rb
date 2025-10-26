class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def total_quantity
    cart_items.sum(:quantity)
  end

  def add(product_id, quantity = 1)
    item = cart_items.find_or_initialize_by(product_id: product_id)
    base = item.persisted? ? item.quantity.to_i : 0
    item.quantity = base + quantity.to_i
    item.save!
  end

  def remove(product_id)
    cart_items.where(product_id: product_id).delete_all
  end

  def update_item(product_id, quantity)
    if quantity.to_i <= 0
      remove(product_id)
    else
      cart_items
        .find_or_initialize_by(product_id: product_id)
        .update!(quantity: quantity.to_i)
    end
  end
end
