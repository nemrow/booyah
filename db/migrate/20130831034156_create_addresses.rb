class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.integer :zip
      t.string :country
      t.integer :user_id
      t.string :lob_address_id
      t.boolean :primary

      t.timestamps
    end
  end
end
