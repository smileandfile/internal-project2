class ChangeExpiryDuration < ActiveRecord::Migration[5.0]
  def change
    rename_column :packages, :expiry_duration, :expiry_duration_months
    change_column :packages, :expiry_duration_months, 'integer USING CAST(expiry_duration_months AS integer)'
  end
end
