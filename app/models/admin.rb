class Admin < ApplicationRecord
  belongs_to :user

  before_save :set_user_properties

  validate :user_does_not_have_other_profiles

  private

  def set_user_properties
    user.properties['platform_access'] = 'all'
    user.properties['account_type'] = 'admin'
    user.save!
  end

  def user_does_not_have_other_profiles
    if user.try(:other) || user.try(:new_other)
      errors.add(:user, 'already has another profile')
    end
  end
end