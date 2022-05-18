class AddGstUrlToGstin < ActiveRecord::Migration[5.0]
  def change
  	add_column :gstins, :gsp_environment, :integer
  end
end
