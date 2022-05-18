# == Schema Information
#
# Table name: contacts
#
#  id            :integer          not null, primary key
#  name          :string
#  email         :string           not null
#  mobile_number :string
#  comment       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer
#

class Contact < ApplicationRecord

  validates :name, presence: true, on: :create
  validates :email, presence: true, on: :create
  validates :mobile_number, presence: true, on: :create
  validates :comment, presence: true, on: :create

  enum status: [:reopened, :assigned, :new_query, :closed]
  after_initialize :set_default_status, if: :new_record?

  scope :reopened_contacts, -> { reopened }
  scope :assigned_contacts, -> { assigned }
  scope :new_contacts, -> { new_query }
  scope :closed_contacts, -> { closed }

  def set_default_status
    self.status ||= :new_query
  end

  rails_admin do
    list do
      scopes [:reopened_contacts, :assigned_contacts, :new_contacts, :closed_contacts,  nil]
    end
  end


end
