class AddAuthTokenExpiresAtToGstin < ActiveRecord::Migration[5.1]
  def change
    add_column :gstins, :auth_token_expires_at, :datetime
  end
end
