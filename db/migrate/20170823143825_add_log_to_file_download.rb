class AddLogToFileDownload < ActiveRecord::Migration[5.0]
  def change
    add_column :file_downloads, :log, :json
  end
end
