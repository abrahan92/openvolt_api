class User < ApplicationRecord
  class WrongCurrentPassword < StandardError; end
  class CreateProfileError < StandardError; end
  class ConfirmUserError < StandardError; end
  class UpdateProfileError < StandardError; end
  class CreateOnStripeError < StandardError; end
  class CreateAccountOnStripeError < StandardError; end
  class LinkAccountOnStripeError < StandardError; end
  class DeleteAccountOnStripeError < StandardError; end

  include ImageUploader::Attachment(:picture)

  rolify
  delegate :can?, :cannot?, to: :ability
  serialize :properties, JsonSerializer
  store_accessor :properties, :platform_access, :account_type, :customer_stripe_identifier
  
  attr_accessor :request_from

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  has_many :access_grants,
           class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :permissions, through: :roles
  has_one :other, dependent: :destroy
  has_one :new_other, dependent: :destroy
  has_one :admin, dependent: :destroy

  validate :only_one_profile

  def self.authenticate!(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  # def self.from_omniauth(auth)
  #   where(email: auth.info.email).first_or_initialize do |user|
  #     user.name = auth.info.name
  #     user.email = auth.info.email
  #     user.password = SecureRandom.hex
  #   end
  # end

  def ability
    @ability ||= Ability.new(self)
  end

  def authenticate_platform_access?(request_from)
    case platform_access
    when 'all'
      true
    when 'web'
      request_from == 'web'
    when 'backoffice'
      request_from == 'backoffice'
    when 'mobile'
      request_from == 'mobile'
    else
      false
    end
  end

  def profile
    new_other || other || admin
  end

  def admin?
    ['admin', 'super_admin'].include?(account_type)
  end

  def other?
    account_type == 'other'
  end

  def new_other?
    account_type == 'new_other'
  end

  def full_name
    "#{name} #{lastname}"
  end

  private

  def only_one_profile
    profiles = []
    profiles << other if other && !other.new_record?
    profiles << new_other if new_other && !new_other.new_record?
    profiles << admin if admin && !admin.new_record?
  
    if profiles.size > 1
      errors.add(:base, 'Only one profile per user is allowed')
    end
  end
end
