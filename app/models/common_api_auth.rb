# == Schema Information
#
# Table name: common_api_auths
#
#  id                    :integer          not null, primary key
#  client_id             :string
#  client_secret         :string
#  username              :string
#  password              :string
#  endpoint_name         :string
#  gsp_environment       :string
#  auth_token            :string
#  auth_token_expires_at :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class CommonApiAuth < ApplicationRecord



  def refresh_auth_token(response)
    begin
      if response['status_cd'] == "1"
        @@gsp_api ||= Gsp::PublicAuthenticatedApi.new()
        response = @@gsp_api.common_authenticate
        self.delay(run_at: (6.hours - 15.minutes).from_now(Time.now)).refresh_auth_token(response)
        # self.delay(run_at: (2.minutes).from_now(Time.now)).refresh_auth_token(response)
      end
    rescue Exception => e
      return true
    end
  end

  def update_auth_token(response, encrypted_app_key)
    auth_token = response['auth_token']
    self.auth_token = auth_token
    self.auth_token_expires_at = Time.now + 6.hours - 10.minutes
    self.encrypted_app_key = encrypted_app_key
  end



end
