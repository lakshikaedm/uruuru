class AddUsernameAndRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :role, :integer, default: 0, null: false
  end
end
