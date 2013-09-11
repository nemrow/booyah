class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :to_id
      t.integer :user_id
      t.string :order_id
      t.string :pdf_source
      t.string :jpg_source
      t.float :lob_cost
      t.float :user_cost
      t.string :lob_object_id

      t.timestamps
    end
  end
end
