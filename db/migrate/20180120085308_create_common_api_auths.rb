class CreateCommonApiAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :common_api_auths do |t|
      t.string :client_id
      t.string "client_secret"
      t.string :username
      t.string :password
      t.string :endpoint_name
      t.string :gsp_environment
      t.string :auth_token
      t.datetime :auth_token_expires_at
  
      t.timestamps
    end
  end
end
