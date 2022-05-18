class AddEndpointNameToGstin < ActiveRecord::Migration[5.0]
  def change
    add_column :gstins, :endpoint_name, :string
  end
end
