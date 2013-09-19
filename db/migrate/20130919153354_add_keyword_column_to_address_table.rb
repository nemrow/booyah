class AddKeywordColumnToAddressTable < ActiveRecord::Migration
  def change
    add_column :addresses, :keyword, :string
  end
end
