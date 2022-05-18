class CreateUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :uploads do |t|
      t.string :name
      t.string :file_url
      t.integer :file_type

      t.timestamps
    end
  end
end
