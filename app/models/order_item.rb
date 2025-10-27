class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :unit_price_yen, :quantity, :line_total_yen, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  before validation :set_line_total, if: -> { unit_price_yen.present? && quantity.present? }

  private

  def set_line_total
    self.line_total_yen = unit_price_yen * quantity
  end
end
