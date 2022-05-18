class ChangeGstinExpiryToDateTime < ActiveRecord::Migration[5.0]
  def up
    add_column :gstins, :auth_expires_at, :datetime
    Gstin.reset_column_information
    Gstin.all.each do |gstin|
      if !gstin.auth_expiry.nil? && gstin.auth_expiry != "" 
        gstin.auth_expires_at = gstin.updated_at + Integer(gstin.auth_expiry).minutes
        gstin.save(validate: false)
      end
    end
    remove_column :gstins, :auth_expiry
  end

  def down
    add_column :gstins, :auth_expiry, :string
    Gstin.reset_column_information
    Gstin.all.each do |gstin|
      gstin.auth_expiry = '720'
      gstin.save(validate: false)
    end
    remove_column :gstins, :auth_expires_at
  end
end
