class CreateIndividualFile < ActiveRecord::Migration[5.0]
  def change
    create_table :individual_files do |t|
      t.string :decrypted_url
      t.integer :state
      t.references :file_download, index: true, foreign_key: true
      t.timestamps
    end
  end
end
