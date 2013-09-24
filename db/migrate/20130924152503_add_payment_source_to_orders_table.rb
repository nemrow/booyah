class AddPaymentSourceToOrdersTable < ActiveRecord::Migration
  def change
    add_column :orders, :payment_source, :string
  end
end
