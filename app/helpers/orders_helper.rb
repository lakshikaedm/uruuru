module OrdersHelper
  def yen(amount)
    number_to_currency(amount, unit: "¥", precision: 0)
  end
end
