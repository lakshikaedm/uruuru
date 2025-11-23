class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug

      t.timestamps
    end

    add_index :brands, :name, unique: true
    add_index :brands, :slug, unique: true
  end
end
