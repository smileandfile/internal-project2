class AddStatusToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :status, :integer
  end
end
