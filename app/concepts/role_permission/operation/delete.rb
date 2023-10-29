class RolePermission::Operation::Delete < Trailblazer::Operation
  step Model(RolePermission, :find_by)
  step Rescue(handler: :handler_error) {
    step :delete_role_permission
  }

  private

  def delete_role_permission(options, model:, **)
    model.destroy
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
