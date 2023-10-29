require 'representable/json'

class Permission::Representer::Default < Representable::Decorator
  include Representable::JSON

  property :id
  property :action_perform
  property :subject
  property :created_at
  property :updated_at

end
