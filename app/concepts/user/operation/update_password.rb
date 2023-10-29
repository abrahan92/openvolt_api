class User::Operation::UpdatePassword < Trailblazer::Operation
  self["contract.default.class"] = User::Contract::UpdatePassword

  step Rescue(handler: :handler_error) {
    step Model(User, :find_by)
    step Policy::Guard(User::Policy::PasswordsMatch, name: "passwords_match")
    step Contract::Build()
    step Contract::Validate()
    step :update_password
    failure :update_password_failed
  }

  private

  def update_password(_options, model:, params:, **)
    current_password = params[:current_password]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    model.update_with_password(current_password: current_password, password: password)
  end

  def update_password_failed(_options, model:, **)
    raise User::WrongCurrentPassword
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end