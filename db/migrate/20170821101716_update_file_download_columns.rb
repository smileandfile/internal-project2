class UpdateFileDownloadColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :file_downloads, :dynamic_attributes, :text
  end
end
