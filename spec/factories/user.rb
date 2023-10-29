FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '12345678' }
    name { Faker::Name.name }
    lastname { Faker::Name.last_name }
    properties do
      {
        platform_access: 'all',
        account_type: 'admin'
      }
    end
    
    after(:create) do |user|
      user.confirm if user.respond_to?(:confirm)
    end

    trait :unconfirmed do
      after(:create) do |user|
        user.update(confirmed_at: nil)
      end
    end

    trait :super_admin_profile do
      properties do
        {
          platform_access: 'all',
          account_type: 'super_admin'
        }
      end

      after(:create) do |user|
        create(:super_admin, user: user)
      end
    end

    trait :other_profile do
      properties do
        {
          platform_access: 'mobile',
          account_type: 'other'
        }
      end

      after(:create) do |user|
        create(:other, user: user)
      end
    end

    trait :new_other_profile do
      properties do
        {
          platform_access: 'mobile',
          account_type: 'new_other'
        }
      end

      after(:create) do |user|
        create(:new_other, user: user)
      end
    end

    trait :admin_profile do
      properties do
        {
          platform_access: 'all',
          account_type: 'admin'
        }
      end

      after(:create) do |user|
        create(:admin, user: user)
      end
    end
  end
end