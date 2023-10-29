require 'representable/json'

class Profile::Representer::Admin < Representable::Decorator
  include Representable::JSON

  property :user_id
end