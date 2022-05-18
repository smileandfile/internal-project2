class AddSpecialTypeOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :special_type, :boolean, default: false
    @orders = Order.all
    @orders.update_all(special_type: false) if @orders.present?
  end
end
