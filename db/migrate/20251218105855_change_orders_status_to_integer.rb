class ChangeOrdersStatusToInteger < ActiveRecord::Migration[7.1]
  def up
    add_column :orders, :status_int, :integer

    execute <<~SQL.squish
      UPDATE orders
      SET status_int =
        CASE status
          WHEN 'pending' THEN 0
          WHEN 'paid' THEN 1
          WHEN 'cancelled' THEN 2
          ELSE 0
        END
    SQL
    remove_column :orders, :status
    rename_column :orders, :status_int, :status

    change_column_default :orders, :status, from: nil, to: 0
    change_column_null :orders, :status, false, 0
  end

  def down
    add_column :orders, :status_str, :string

    execute <<~SQL.squish
      UPDATE orders
      SET status_str =
        CASE status
          WHEN 0 THEN 'pending'
          WHEN 1 THEN 'paid'
          WHEN 2 THEN 'cancelled'
          ELSE 'pending'
        END
    SQL

    remove_column :orders, :status
    rename_column :orders, :status_str, :status

    change_column_default :orders, :status, from: nil, to: "pending"
    change_column_null :orders, :status, true
  end
end
