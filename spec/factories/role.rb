# spec/faclories/role.rb

FactoryBot.define do
  factory :role do
    name { 'admin' }

    after(:create) do |role|
      permission = Permission.first || create(:permission)
      
      role.permissions << permission
    end
  end

  trait :super_admin do
    name { 'super_admin' }
  end

  trait :other do
    name { 'other' }
  end

  trait :new_other do
    name { 'new_other' }
  end
end