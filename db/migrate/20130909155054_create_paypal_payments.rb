class CreatePaypalPayments < ActiveRecord::Migration
  def change
    create_table :paypal_payments do |t|
      t.string :status
      t.string :transaction_id
      t.integer :order_id

      t.timestamps
    end
  end
end
