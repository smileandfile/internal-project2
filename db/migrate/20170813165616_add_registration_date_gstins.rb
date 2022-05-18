class AddRegistrationDateGstins < ActiveRecord::Migration[5.0]
  def change
    add_column :gstins, :registration_date, :datetime
  end
end
