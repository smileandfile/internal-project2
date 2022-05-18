class ChangeColumnNameIndividualFiles < ActiveRecord::Migration[5.1]
  def change
    rename_column :individual_files, :hash, :hash_value
    rename_column :individual_files, :download_url, :encrypted_file
    rename_column :individual_files, :decrypted_url, :decrypted_file
    add_column :individual_files, :filename, :string
  end
end
