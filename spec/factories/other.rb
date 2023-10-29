# spec/factories/other.rb

FactoryBot.define do
  factory :other do
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 90) }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }

    # Associations
    user { create(:user, :other_profile) }
  end
end
