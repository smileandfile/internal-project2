class AddEndEwaybill < ActiveRecord::Migration[5.1]
  def change
    add_column :ewaybills, :endpoint_name, :string
    add_column :ewaybills, :eway_environment, :integer

  end
end
