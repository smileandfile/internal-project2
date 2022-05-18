# == Schema Information
#
# Table name: sub_packages
#
#  id            :integer          not null, primary key
#  turnover_from :integer
#  turnover_to   :integer
#  annual        :integer
#  half_yearly   :integer
#  quarterly     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  package_id    :integer
#

class SubPackage < ApplicationRecord
  belongs_to :package
end
