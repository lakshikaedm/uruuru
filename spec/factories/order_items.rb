FactoryBot.define do
  factory :order_item do
    order { nil }
    product { nil }
    unit_price_yen { 1 }
    quantity { 1 }
    line_total_yen { 1 }
  end
end
