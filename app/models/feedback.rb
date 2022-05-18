# == Schema Information
#
# Table name: feedbacks
#
#  id            :integer          not null, primary key
#  name          :string
#  domain        :string
#  email         :string
#  mobile_number :string
#  comment       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Feedback < ApplicationRecord

  validates :name, presence: true, on: :create
  validates :email, presence: true, on: :create
  validates :domain, presence: true, on: :create
  validates :mobile_number, presence: true, on: :create
  validates :comment, presence: true, on: :create

  after_create :send_support_mail

  def send_support_mail
    UserMailer.delay.user_feedback(self)
  end

end
