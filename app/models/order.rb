class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  STATUSES = %w[pending placed cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :subtotal_yen, :shipping_yen, :total_yen, numericality: { greater_than_or_equal_to: 0 }

  def recalculate_totals!
    self.subtotal_yen = order_items.to_a.sum { |i| i.line_total_yen.to_i }
    self.total_yen    = subtotal_yen.to_i + shipping_yen.to_i
  end
end
