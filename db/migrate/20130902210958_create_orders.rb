class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :to_id
      t.integer :user_id
      t.string :order_id
      t.decimal :lob_cost
      t.decimal :user_cost

      t.timestamps
    end
  end
end
