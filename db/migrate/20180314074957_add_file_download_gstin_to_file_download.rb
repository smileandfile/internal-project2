class AddFileDownloadGstinToFileDownload < ActiveRecord::Migration[5.1]
  def change
    add_reference :file_downloads, :file_download_gstin
  end
end
