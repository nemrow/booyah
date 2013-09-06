class CreatePaypalPreapprovals < ActiveRecord::Migration
  def change
    create_table :paypal_preapprovals do |t|
      t.string :key
      t.integer :user_id
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end
