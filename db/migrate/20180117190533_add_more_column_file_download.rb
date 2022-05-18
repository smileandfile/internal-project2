class AddMoreColumnFileDownload < ActiveRecord::Migration[5.1]
  def change
    add_column :file_downloads, :file_eta, :datetime
    add_column :file_downloads, :waiting_message, :string
  end
end
