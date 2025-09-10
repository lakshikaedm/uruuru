class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :username, unique: true unless index_exists?(:users, :username)
  end
end
