# spec/factories/admin.rb

FactoryBot.define do
  factory :admin do

    # Associations
    user { create(:user, :admin_profile) }
  end
end
