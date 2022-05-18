# == Schema Information
#
# Table name: gst_access_items
#
#  id                    :integer          not null, primary key
#  username              :string
#  domain                :string
#  requested_at          :datetime
#  gstin                 :string
#  return_period         :string
#  request_headers       :json
#  api_name              :string
#  request_payload_size  :integer
#  transaction_id        :string
#  ip_address            :string
#  response_at           :datetime
#  response_type         :string
#  invalid_reason        :string
#  response_headers      :json
#  reference_id          :string
#  user_email            :string
#  response_payload_size :integer
#  base_url              :string
#  user_id               :integer
#

class GstAccessItem < ApplicationRecord
  include Swagger::Blocks

 self.per_page = 50

end
