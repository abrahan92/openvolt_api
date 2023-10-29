class User::Operation::ListNewOthers < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step Policy::Guard(User::Policy::ActionAllowedForAdmin, name: "action_allowed_for_admin")
    step :list
  }

  private

  def list(options, **)
    options[:model] = NewOther.all.to_a
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
