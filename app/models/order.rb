class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, paid: 1, cancelled: 2 }, default: :pending

  validates :shipping_name,
            :shipping_phone,
            :shipping_postal_code,
            :shipping_prefecture,
            :shipping_city,
            :shipping_address1,
            presence: true

  validates :subtotal_yen, :shipping_yen, :total_yen, numericality: { greater_than_or_equal_to: 0 }

  def recalculate_totals!
    self.subtotal_yen = order_items.to_a.sum { |i| i.line_total_yen.to_i }
    self.total_yen    = subtotal_yen.to_i + shipping_yen.to_i
  end
end
