class ChangeOrderIdToLobOrderIdInOrdersTable < ActiveRecord::Migration
  def up
    rename_column :orders, :order_id, :lob_order_id
  end

  def down
    rename_column :orders, :lob_order_id, :order_id
  end
end
