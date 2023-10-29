require 'representable/json'

class User::Representer::List < Representable::Decorator
  include Representable::JSON

  property :id
  property :email
  property :created_at
  property :updated_at
end