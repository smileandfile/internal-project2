class CreateFileDownloads < ActiveRecord::Migration[5.0]
  def change
    create_table :file_downloads do |t|
      t.references :user, foreign_key: true
      t.references :gstin
      t.integer :est
      t.string :ek
      t.string :token
      t.string :file_count
      t.text :dynamic_attributes

      t.timestamps
    end
  end
end
