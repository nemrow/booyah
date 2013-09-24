class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :pdf_source
      t.string :jpg_source
      t.string :lob_object_id
      t.integer :order_id

      t.timestamps
    end
  end
end
