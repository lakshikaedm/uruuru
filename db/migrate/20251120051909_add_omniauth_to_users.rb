class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string unless column_exists?(:users, :provider)
    add_column :users, :uid, :string unless column_exists?(:users, :uid)

    return if index_exists?(:users, %i[provider uid])

    add_index :users, %i[provider uid], unique: true
  end
end
