# == Schema Information
#
# Table name: domains
#
#  id                 :integer          not null, primary key
#  name               :citext
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  address            :text
#  firm_turnover      :string
#  is_active          :boolean          default(FALSE)
#  package_id         :integer
#  package_start_date :datetime
#  package_end_date   :datetime
#  working_level      :integer
#

class Domain < ApplicationRecord
  include Swagger::Blocks

  rails_admin do
    show do
      configure :updated_at do
        show
      end
    end
  end 

  swagger_schema :Domain do
    key :required, [:name]
    property :id do
      key :type, :integer
    end
    property :name do
      key :type, :string
    end
    property :user_id do
      key :type, :integer
    end
    property :package_id do
      key :type, :integer
    end
    property :package_start_date do
      key :type, :string
    end
    property :package_end_date do
      key :type, :string
    end
    property :super_user_name do
      key :type, :string
    end
    property :super_user_email do
      key :type, :string
    end
    property :super_user_mobile do
      key :type, :string
    end
    property :number_of_entities do
      key :type, :integer
    end
    property :number_of_gstins do
      key :type, :integer
    end
    property :number_of_users do
      key :type, :integer
    end
    property :updated_at do
      key :type, :datetime
    end
  end

  has_many :entities, dependent: :destroy
  has_many :gstins, dependent: :destroy, through: :entities
  has_many :users, dependent: :destroy

  belongs_to :user
  belongs_to :package
  enum working_level: [:gstin, :branch]
  accepts_nested_attributes_for :user, reject_if: :all_blank
  accepts_nested_attributes_for :package, reject_if: :all_blank

  scope :branch_levels, -> { where(working_level: :branch) }

  validates :name, presence: true,
                   length: { is: 8 },
                   uniqueness: true,
                   format: {
                     with: /[a-zA-Z]{8}/
                   }, on: :create

  def make_domain_active(package, order)
    if order.subscription_changed? && order.subscription.to_sym == :active
      self.package = package
      self.package_start_date = Time.now
      if order.duration_months.nil?
        self.package_end_date = Time.now + package.expiry_duration_months.months
      else
        self.package_end_date = Time.now + order.duration_months.months
      end
      self.is_active = true
      save!
      order.generate_invoice_number
      order.save!
      if self.package.is_package_credit_type
        create_associated_account
      end
      delay(run_at: package_end_date).make_domain_inactive
      UserMailer.delay.domain_created(self)
      MaccessmpushSMSSender.new.delay.domain_active(self)
    end
    true
  end

  def make_domain_inactive
    self.package = nil
    self.package_start_date = nil
    self.package_end_date = nil
    self.is_active = false
    save
  end

  def create_associated_account
    account = Account.new
    account.domain = self
    account.description = ""
    per_gstin_amount = 150
    if self.package.package_type.to_sym == :gst_suvidha_kendra
      account.gstin_allowed_left = 0
      account.credits = package.gsp_deposit_amount
    elsif self.package.package_type.to_sym == :professionals_and_tax_advisers
      account.gstin_allowed_left = 50
      per_gstin_amount = 200
      account.credits = 0
    end
    account.per_gstin_amount = per_gstin_amount
    account.save
  end

  def entities_count
    @entities_count = entities.count
  end

  def gstins
    @gstins  = Gstin.where(entity: entities)
  end

  def domain_users
    users.where(role: :user)
  end

  def find_by_name(name)
    where(name: name).first
  end

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :name , :user_id, :package_id, :package_start_date, :package_end_date, :updated_at)
      if user.present?
        json.super_user_name user.name
        json.super_user_email user.email
        json.super_user_mobile user.phone_number
      end
      json.number_of_entities entities.count
      json.number_of_gstins gstins.count
      json.number_of_users users.count
    end
  end

  def account_details
    Account.where(domain: self).first
  end



end