class CreateAuthTokenCreationTime < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_token_creation_times do |t|
      add_column :eway_bill_multiple_auths, :token_created_at, :datetime
    end
  end
end
