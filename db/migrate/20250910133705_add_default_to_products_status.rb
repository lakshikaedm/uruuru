class AddDefaultToProductsStatus < ActiveRecord::Migration[7.1]
  def up
    # Set existing NULL statuses to 0 (draft) before adding constraints.
    # rubocop:disable Rails/SkipsModelValidations
    Product.where(status: nil).update_all(status: 0)
    # rubocop:enable Rails/SkipsModelValidations

    change_table :products, bulk: true do |t|
      t.change_default :status, 0
      t.change_null :status, false
    end
  end

  def down
    change_table :products, bulk: true do |t|
      t.change_null :status, true
      t.change_default :status, nil
    end
  end
end
