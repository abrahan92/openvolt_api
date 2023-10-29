class User::Operation::Delete < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step Policy::Guard(User::Policy::ActionAllowedForAdmin, name: "action_allowed_for_admin")
    step Model(User, :find_by)
    step :delete_user
  }

  private

  def delete_user(options, model:, **)
    model.destroy
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
