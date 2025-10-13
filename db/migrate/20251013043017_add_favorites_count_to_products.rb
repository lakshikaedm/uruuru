class AddFavoritesCountToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :favorites_count, :integer, default: 0, null: false
  end
end
