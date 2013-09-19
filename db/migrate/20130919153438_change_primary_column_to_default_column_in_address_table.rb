class ChangePrimaryColumnToDefaultColumnInAddressTable < ActiveRecord::Migration
  def up
    rename_column :addresses, :primary, :default
  end

  def down
    rename_column :addresses, :default, :primary
  end
end
