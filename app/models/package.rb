# == Schema Information
#
# Table name: packages
#
#  id                     :integer          not null, primary key
#  name                   :string
#  package_type           :integer
#  cost                   :integer
#  description            :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  expiry_duration_months :integer
#  turnover_from          :string
#  turnover_to            :string
#

class Package < ApplicationRecord
  # TODO convert cost to integer and paisas

  validates :name, presence: true, on: :create
  validates :cost, presence: true, on: :create
  validates :expiry_duration_months, presence: true, on: :create
  validates :package_type, presence: true, on: :create

  enum package_type: [:only_gstr3b, :composition_dealer, :normal_tax_payer,
                      :special, :gst_suvidha_kendra, :professionals_and_tax_advisers]

  has_many :sub_packages

  def gst_amount
    cost * gst_rate / 100
  end

  def total_amount
    cost + gst_amount
  end

  def gst_rate
    18.to_f
  end

  def gsp_deposit_amount
    5000
  end

  def take_deposit
    take_deposit = self.package_type.to_sym == :gst_suvidha_kendra
    take_deposit ? gsp_deposit_amount : 0 
  end

  def is_package_credit_type
    package_type.to_sym == :gst_suvidha_kendra || package_type.to_sym == :professionals_and_tax_advisers
  end



end
