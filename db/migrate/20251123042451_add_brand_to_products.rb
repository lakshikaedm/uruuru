class AddBrandToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :brand, foreign_key: true, null: true
  end
end
