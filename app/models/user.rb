# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  role                   :integer
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  branch_id              :integer
#  domain_id              :integer
#  phone_number           :string
#  phone_verified_at      :datetime
#  otp_secret_key         :string
#  email_otp              :integer
#

DEFAULT_ALLOWED_ACTIONS =   {
   'gstins': ['index', 'edit', 'show', 'delete', 'update'],
   'entities': ['index', 'edit', 'show', 'delete', 'update'],
   'gstn_auth': ['request_otp', 'confirm_otp'],
   'users': ['index', 'edit', 'show', 'update']
  }




class User < ApplicationRecord
  # These must come before DeviseTokenAuth
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User
  include Swagger::Blocks


  rails_admin do
    list do
      field :id
      field :name
      field :domain
      field :email
      field :phone_number
    end
    edit do
      configure :confirmation_token do
        hide
      end
    end 
  end 


  swagger_schema :User do
    key :required, [:domain_id, :email]
    property :id do
      key :type, :integer
    end
    property :name do
      key :type, :string
    end
    property :domain_id do
      key :type, :integer
      key :format, :int64
    end
    property :email do
      key :type, :string
    end
    property :uid do
      key :type, :string
    end
    property :role do
      key :type, :string
    end
    property :phone_number do
      key :type, :string
    end
    property :encrypted_password do
      key :type, :string
    end
    property :permissions do
      key :type, :object
      property :entities do
        key :type, :array
        items do
          key :'$ref', :Entity
        end
      end
      property :gstins do
        key :type, :array
        items do
          key :'$ref', :Gstin
        end
      end
      property :roles do
        key :type, :array
        items do
          key :'$ref', :Role
        end
      end
    end
  end

  belongs_to :domain
  has_many :orders, dependent: :destroy

  enum role: [:super, :admin, :user]
  after_initialize :set_default_role, if: :new_record?
  after_initialize :set_email_otp, if: :new_record?
  before_save :touch_domain
  before_destroy :update_domain_timestamp

  # used in login
  attr_accessor :domain_name

  validates :email, presence: true
  validates_uniqueness_of :email, scope: [:domain], 
                          allow_blank: false
  validates_format_of :email, with: Devise.email_regexp, 
                      allow_blank: true
  validates_presence_of :password, if: :password_required?  
  validates_confirmation_of :password, if: :password_required? 
  validates :password, length: { minimum: 8 },
                       allow_blank: false,
                       format: {
                         with: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/,
                         message: I18n.t(:password_hint),
                         multiline: true
                       }, on: :create
  validates :name, presence: true
  validates :phone_number, presence: true
  has_one_time_password length: 4
  # Normalizes the attribute itself before validation
  phony_normalize :phone_number, default_country_code: 'IN'
  # Validates phone number
  validates_plausible_phone :phone_number

  after_create :new_user_created, if: :user?

  has_and_belongs_to_many :entities, dependent: :destroy, after_add: :update_domain_timestamp, after_remove: :update_domain_timestamp
  has_and_belongs_to_many :gstins, dependent: :destroy, after_add: :update_domain_timestamp, after_remove: :update_domain_timestamp
  has_and_belongs_to_many :branches, dependent: :destroy, after_add: :update_domain_timestamp, after_remove: :update_domain_timestamp
  has_and_belongs_to_many :roles, dependent: :destroy, after_add: :update_domain_timestamp, after_remove: :update_domain_timestamp

  def set_default_role
    self.role ||= :user
  end

  def admin?
    self.role == 'admin'
  end

  def user?
    self.role == 'user'
  end

  def set_email_otp
    self.email_otp ||= SecureRandom.random_number(9999)
  end

  def super_admin?
    self.role == 'super'
  end

  def domain_admin?
    domain = Domain.where(user: self).first
    domain.present?
  end

  #TODO relationship between user and domain level
  def selected_gstin
    Gstin.last
  end

  def touch_domain
    domain&.touch if changed_attributes.present? && changed_attributes.select {|k,v| ["name", "email", "confirmed_at", "phone_verified_at", "phone_number", "encrypted_password"] \
                                                                      .include?(k) } \
                                                                      .present?
  end

  def update_domain_timestamp(*)
    domain&.touch
  end


  def current_react_token
    existing_token = tokens && tokens[react_token_client_id]
    existing_token_value = existing_token && (existing_token[:token] || existing_token['token'])
    if existing_token.present? && token_is_current?(existing_token_value, react_token_client_id)
      build_auth_header(existing_token_value, react_token_client_id)
    else
      create_new_auth_token(react_token_client_id)
    end
  end

  # added domain name in headers while searching for user authentication (domain name + email)
  def build_auth_header(*)
    super.merge!('uid' => email, 'domain-name' => domain.name)
  end

  def react_token_client_id
    'react-client'
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def new_user_created
    UserMailer.delay.new_user_created(self)
    MaccessmpushSMSSender.new.delay.new_user_created(self)
  end

  def check_domain(name)
    domain.name.downcase == name.downcase
  end

  def has_active_package?
    return domain.package_end_date >= Time.now && domain.package.present? unless domain.package_end_date.nil?
    false
  end

  def email_confirmed?
    confirmed_at.present?
  end

  def phone_confirmed?
    phone_verified_at.present?
  end

  def can_access_action(controller_name, action_name)
    return true if default_allowed_actions(controller_name, action_name)
    full_name = make_controller_action_name(controller_name, action_name)
    roles.where("'#{full_name}' = ANY (allowed_actions)").present?
  end

  def make_controller_action_name(contoller_name, action_name)
    contoller_name.split('_').first + "##{action_name}"
  end

  def default_allowed_actions(controller_name, action_name)
    controller = DEFAULT_ALLOWED_ACTIONS[controller_name.to_sym]
    return true if controller.present? && controller.include?(action_name)
    return false
  end

  def accessed_roles
    if super_admin? || admin?
      roles.where(name: 'All Actions')
    else
      roles.where.not(parent_id: nil)
    end
  end

  def authenticate_otp(*)
    success = super
    if success
      self.phone_verified_at = Time.now
      save
    else
      false
    end
  end

  def authenticate_otp_email(otp)
    success = email_otp.to_s == otp
    if success
      self.confirmed_at = Time.now
      save
    else
      false
    end
  end

  def otp_confirmed?(type)
    if type == :mobile || type.to_sym == :mobile
      phone_confirmed?
    else
      email_confirmed?
    end
  end

  def both_otps_validated?
    email_confirmed? && phone_confirmed?
  end

  def send_otp_mobile
    response = MaccessmpushSMSSender.new.domain_created(self)
    response.present? # && response.to_i < 0
  end

  def send_otp_email
    response = UserMailer.new_user_otp_email(self).deliver
    response.present?
  end

  # does domain id check during devise login
  def self.find_for_authentication(conditions={})
    conditions[:domain_id] = Domain.find_by_name(conditions.delete(:domain_name))&.id
    super(conditions)
  end

  def as_json(*)
    super.merge!(domain_name: domain&.name, encrypted_password: encrypted_password)
  end

  def to_builder(permission_ids_only: false)
    Jbuilder.new do |json|
      json.call(self, :id, :email, :phone_number, :name, :role, :domain_id, :encrypted_password)
      if permission_ids_only
        json.gstin_ids gstins.map(&:id)
        json.role_ids roles.map(&:id)
        json.entity_ids entities.map(&:id)
      end
      json.permissions do
        json.entities(entities.map { |i| i.to_builder.attributes! })
        json.gstins(gstins.map { |i| i.to_builder.attributes! })
        json.roles(roles.map { |i| i.to_builder.attributes! })
      end
      json.uid email
    end
  end

  def get_order
    orders.where(subscription: :deactive).last
  end

  def get_special_order
    orders.where(subscription: :deactive).where(special_type: true).last
  end

    # Override Devise::Confirmable#after_confirmation
  def after_confirmation
   MaccessmpushSMSSender.new.delay.domain_created(self) if role == :user
  end

  def account_details
    @account = Plutus::Asset.find_by_name(domain.name)
  end

  private

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
