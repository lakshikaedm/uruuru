class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true

      # money (JPY, store as integer yen)
      t.integer :subtotal_yen, null: false, default: 0
      t.integer :shipping_yen, null: false, default: 0
      t.integer :total_yen,    null: false, default: 0

      t.string :status, null: false, default: "pending"

      # shipping address
      t.string :status, null: false
      t.string :shipping_name, null: false
      t.string :shipping_phone, null: false
      t.string :shipping_postal_code, null: false
      t.string :shipping_prefecture, null: false
      t.string :shipping_city, null: false
      t.string :shipping_address1, null: false
      t.string :shipping_address2, null: false, default: ""

      t.timestamps
    end
  end
end
