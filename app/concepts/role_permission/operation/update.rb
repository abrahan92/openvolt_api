class RolePermission::Operation::Update < Trailblazer::Operation
  step Policy::Guard(RolePermission::Policy::RoleAndPermissionMustExists, name: "role_and_permission_must_exists")
  step Model(RolePermission, :find_by)
  step Rescue(handler: :handler_error) {
    step Contract::Build(constant: RolePermission::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()
  }

  private

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
