class AddResponseToFileDownload < ActiveRecord::Migration[5.1]
  def change
    add_column :file_downloads, :gst_response, :json
  end
end