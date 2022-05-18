class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :amount, null:false
      t.string :currency, null:false
      t.string :tracking_id
      t.string :billing_name
      t.string :billing_address
      t.string :billing_zip
      t.string :billing_city
      t.string :billing_state
      t.string :billing_country
      t.string :billing_tel
      t.string :billing_email
      t.string :delivery_name
      t.string :delivery_address
      t.string :delivery_city
      t.string :delivery_state
      t.string :delivery_country
      t.string :delivery_tel
      t.string :promo_code
      t.string :discounted_amount
      t.integer :status
      t.string :cc_avenue_order_status
      t.string :bank_ref_no
      t.string :failure_message
      t.string :payment_mode
      t.string :card_name
      t.string :status_code
      t.string :status_message
      t.string :merchant_param1
      t.string :merchant_param2
      t.string :merchant_param3
      t.string :merchant_param4
      t.string :merchant_param5
      t.string :vault
      t.string :offer_type
      t.string :offer_code
      t.string :discount_value
      t.string :mer_amount
      t.string :eci_value
      t.string :retry
      t.string :response_code
      t.string :billing_notes
      t.string :trans_date
      t.string :bin_country
      t.references :package
      t.references :user
      t.timestamps
    end
  end
end
