class RolePermission::Operation::Create < Trailblazer::Operation
  step Policy::Guard(RolePermission::Policy::RoleAndPermissionMustExists, name: "role_and_permission_must_exists")
  step Model(RolePermission, :new)
  step Contract::Build(constant: RolePermission::Contract::Create)
  step Contract::Validate()
  step Rescue(handler: Trailblazer::Handler::DefaultApiError) {
    step Contract::Persist()
  }
end
