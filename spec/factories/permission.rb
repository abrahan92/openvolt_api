# spec/factories/permission.rb

FactoryBot.define do
  factory :permission do
    subject { 'home' }
    action_perform { 'read' }
  end
end