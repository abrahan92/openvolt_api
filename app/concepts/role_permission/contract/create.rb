class RolePermission::Contract::Create < Reform::Form
  feature Dry

  property :role_id
  property :permission_id

  validation name: :default do
    params do
      required(:role_id).filled(:int?)
      required(:permission_id).filled(:int?)
    end
  end
end