class TokenInOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :token, :string
    add_column :orders, :is_payment_url_sent, :boolean, default: false
  end
end
