# spec/factories/access_token.rb

FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    association :application, factory: :oauth_application
    resource_owner_id { create(:user).id }
    expires_in { Doorkeeper.configuration.access_token_expires_in }
    scopes { "" }
  end
end
