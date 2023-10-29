class Role::Operation::Update < Trailblazer::Operation
  self["contract.default.class"] = Role::Contract::Update
  
  step Rescue(handler: :handler_error) {
    step Model(Role, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step :assign_permissions
    step Contract::Persist()
  }

  private

  def assign_permissions(options, params:, **)
    return true unless params[:permission_ids].present?
    
    options[:model].permissions = Permission.where(id: params[:permission_ids])
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
