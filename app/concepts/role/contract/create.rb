require 'types/types'

class Role::Contract::Create < Reform::Form
  feature Dry

  property :name
  property :resource_type
  property :resource_id
  property :permission_ids, virtual: true

  validation name: :default do
    params do
      required(:name).filled(:str?, :included_in? => %w[super_admin admin new_other other])
      optional(:resource_type).maybe(:str?, max_size?: 255)
      optional(:resource_id).maybe(:int?)
      required(:permission_ids).filled(:array?, min_size?: 1) { each(:int?) }
    end
  end
end