# spec/factories/doorkeeper.rb

FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { Faker::Company.name }
    redirect_uri { "https://app.com/callback" }
    secret { Doorkeeper::OAuth::Helpers::UniqueToken.generate }
    uid { Doorkeeper::OAuth::Helpers::UniqueToken.generate }
  end
end