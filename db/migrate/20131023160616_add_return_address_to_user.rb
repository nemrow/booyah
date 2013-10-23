class AddReturnAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :return_lob_address_id, :string
  end
end
