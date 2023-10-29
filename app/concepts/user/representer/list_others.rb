require 'representable/json'

class User::Representer::ListOthers < Representable::Decorator
  include Representable::JSON

  property :id
  property :birthdate
  property :phone_number
  property :user_id
end