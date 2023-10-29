require 'representable/json'

class Profile::Representer::Other < Representable::Decorator
  include Representable::JSON

  property :birthdate
  property :phone_number
  property :user_id
end