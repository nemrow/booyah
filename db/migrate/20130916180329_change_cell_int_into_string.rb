class ChangeCellIntIntoString < ActiveRecord::Migration
  def up
    change_column :addresses, :zip, :string
  end

  def down
    change_column :addresses, :zip, :integer
  end
end
