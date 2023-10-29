require 'representable/json'

class User::Representer::DoorkeeperUser < Representable::Decorator
  include Representable::JSON

  property :id
  property :email
  property :created_at
  property :updated_at
  property :provider
  property :name
  property :lastname
  property :properties
  property :profile, getter: ->(represented:, **) do
    if represented.properties[:account_type] == 'other'
      represented.try(:other)
    elsif represented.properties[:account_type] == 'new_other'
      represented.try(:new_other)
    else
      represented.try(:admin)
    end
  end, 
  decorator: ->(represented:, **) do
    if represented.properties[:account_type] == 'other'
      Profile::Representer::Other
    elsif represented.properties[:account_type] == 'new_other'
      Profile::Representer::NewOther
    else
      Profile::Representer::Admin
    end
  end
  property :picture_url
  property :confirmed_at
  collection :roles
  property :default_role, getter: ->(represented:, **) do
    represented.roles.first
  end
end