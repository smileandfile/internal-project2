# == Schema Information
#
# Table name: eway_api_logs
#
#  id                :integer          not null, primary key
#  requested_at      :datetime
#  gstin             :string
#  request_headers   :json
#  api_name          :string
#  response_at       :datetime
#  response_type     :string
#  invalid_reason    :string
#  response_headers  :json
#  base_url          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  eway_bill_user_id :integer
#

class EwayApiLog < ApplicationRecord
  self.per_page = 50

  after_update :increase_request_count, unless: Proc.new { self.api_name == "ACCESSTOKEN" }

  belongs_to :eway_bill_user, class_name: 'Ewaybill'

  def increase_request_count
    eway_bill_user.bill_request_count = (eway_bill_user.bill_request_count.nil? ? 0 : eway_bill_user.bill_request_count) + 1
    eway_bill_user.save
  end

end
