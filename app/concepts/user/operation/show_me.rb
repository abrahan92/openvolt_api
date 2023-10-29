class User::Operation::ShowMe < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step :show_me
  }

  private

  def show_me(options, current_user:, **)
    options[:model] = current_user
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
