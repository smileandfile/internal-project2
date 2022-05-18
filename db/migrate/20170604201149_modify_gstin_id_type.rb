class ModifyGstinIdType < ActiveRecord::Migration[5.0]
  def up
    change_column :gstins, :gstin_number, :string
  end

  def down
    change_column :gstins, :gstin_number, :bigint
  end
end
