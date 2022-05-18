# == Schema Information
#
# Table name: uploads
#
#  id         :integer          not null, primary key
#  name       :string
#  file_url   :string
#  file_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Upload < ApplicationRecord
  enum file_type: [:excels, :others]
  mount_uploader :file_url, FileUploader
end
