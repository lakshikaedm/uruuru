class AddDefaultToProductsStatus < ActiveRecord::Migration[7.1]
  def up
    change_column_default :products, :status, from: nil, to: 0
    Product.where(status: nil).update_all(status: 0)
    change_column_null :products, :status, false
  end

  def down
    change_column_null :products, :status, true
    change_column_default :products, :status, from: 0, to: nil
  end

end
