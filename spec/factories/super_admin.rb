# spec/factories/super_admin.rb

FactoryBot.define do
  factory :super_admin do

    # Associations
    user { create(:user, :super_admin_profile) }
  end
end