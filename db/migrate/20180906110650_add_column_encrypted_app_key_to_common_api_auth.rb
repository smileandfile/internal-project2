class AddColumnEncryptedAppKeyToCommonApiAuth < ActiveRecord::Migration[5.1]
  def change
    add_column :common_api_auths, :encrypted_app_key, :string
  end
end
