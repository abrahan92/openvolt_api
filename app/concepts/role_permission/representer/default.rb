require 'representable/json'

class RolePermission::Representer::Default < Representable::Decorator
  include Representable::JSON

  property :id
  property :role_id
  property :permission_id

end
