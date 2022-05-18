# == Schema Information
#
# Table name: snf_settings
#
#  id           :integer          not null, primary key
#  whats_new    :text
#  faqs         :text
#  gstin_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SnfSetting < ApplicationRecord
end
