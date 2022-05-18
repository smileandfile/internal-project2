class OrderDurationTypeCastInteger < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :duration, :duration_months
    Order.where(duration_months: "").update_all(duration_months: nil)
    change_column :orders, :duration_months, 'integer USING CAST(duration_months AS integer)'
  end
end
