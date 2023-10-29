class User::Operation::Show < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step Policy::Guard(User::Policy::ActionAllowedForUser, name: "action_allowed_for_user")
    step Model(User, :find_by)
  }

  private

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
