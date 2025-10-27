class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.integer :unit_price_yen, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :line_total_yen, null: false

      t.timestamps
    end
  end
end
