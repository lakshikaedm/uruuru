class AddCategoryToProducts < ActiveRecord::Migration[7.1]
  def up
    add_reference :products, :category, foreign_key: true, null: true

    say_with_time "Backfilling products.category_id" do
      uncategorized = Category.find_or_create_by!(name: "Uncategorized", slug: "uncategorized")
      Product.where(category_id: nil).update_all(category_id: uncategorized.id)
    end

    change_column_null :products, :category_id, false
  end

  def down
    remove_reference :products, :category, foreign_key: true
  end
end
