class AddEmailOtpToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_otp, :integer
  end
end
