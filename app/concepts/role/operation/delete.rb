class Role::Operation::Delete < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step Model(Role, :find_by)
    step :delete_role
  }

  private

  def delete_role(options, model:, **)
    model.destroy
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
