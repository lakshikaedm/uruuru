class AddShippingFeeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_yen, :integer, null: false, default: 0
  end
end
