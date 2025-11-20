class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  change_table :users, bulk: true do |t|
    t.string :provider
    t.string :uid

    add_index :users, %i[provider uid], unique: true
  end
end
