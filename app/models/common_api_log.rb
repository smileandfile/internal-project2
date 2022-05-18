# == Schema Information
#
# Table name: common_api_logs
#
#  id               :integer          not null, primary key
#  requested_at     :datetime
#  gstin            :string
#  request_headers  :json
#  api_name         :string
#  response_at      :datetime
#  response_type    :string
#  invalid_reason   :string
#  response_headers :json
#  username         :string
#  base_url         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CommonApiLog < ApplicationRecord
  self.per_page = 50


  def party_name
    Asp.find_by_username(self.username)&.party_name
  end
end
