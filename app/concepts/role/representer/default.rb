require 'representable/json'

class Role::Representer::Default < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :resource_type
  property :resource_id
  property :total_users
  collection :permissions, extend: Permission::Representer::Default, class: Permission

end
