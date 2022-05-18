class UpdateAdditionalDownloadFields < ActiveRecord::Migration[5.0]
  def change
    change_column :file_downloads, :file_count, 'integer USING CAST(file_count AS integer)'
    add_column :file_downloads, :user_ip, :string
    add_column :file_downloads, :return_period, :string
    add_column :individual_files, :download_url, :string
    add_column :individual_files, :invoice_count, :integer
    add_column :individual_files, :hash, :string
  end
end
