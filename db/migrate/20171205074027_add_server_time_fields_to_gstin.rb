class AddServerTimeFieldsToGstin < ActiveRecord::Migration[5.1]
  def change
    add_column :gstins, :server_time, :datetime
    add_column :gstins, :actual_time_of_token_expires, :integer
    @gstins = Gstin.all
    unless @gstins.empty?
      @gstins.each do |gstin|
        gstin.server_time = Time.now
        gstin.actual_time_of_token_expires = gstin.auth_expires_at - gstin.server_time unless gstin.auth_expires_at.nil?
        gstin.save
      end
    end
  end
end
