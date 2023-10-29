class Other < ApplicationRecord
  belongs_to :user

  before_save :set_user_properties

  validate :user_does_not_have_other_profiles

  private

  def set_user_properties
    user.properties['platform_access'] = 'mobile'
    user.properties['account_type'] = 'other'
    user.save!
  end

  def user_does_not_have_other_profiles
    if user.try(:new_other) || user.try(:admin)
      errors.add(:user, 'already has another profile')
    end
  end
end