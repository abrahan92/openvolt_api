class User::Operation::BaseCreate < Trailblazer::Operation
  self["contract.default.class"] = User::Contract::Create

  step Rescue(handler: :handler_error) {
    step Policy::Guard(User::Policy::EmailIsAvailable, name: "email_is_available")
    step Policy::Guard(User::Policy::UserNotAllowedSignUp, name: "user_not_allowed_sign_up")
    step Model(User, :new)
    step Policy::Guard(User::Policy::RolesCountMustBeOne, name: "roles_count_must_be_one")
    step Policy::Guard(User::Policy::RoleNotExist, name: "role_not_exist")
    step Policy::Guard(User::Policy::PasswordsMatch, name: "passwords_match")
    step :assign_roles
    step Policy::Guard(User::Policy::RoleNotAllowed, name: "role_not_allowed")
    step Contract::Build()
    step Contract::Validate()
      step Wrap(Trailblazer::ActiveRecordTransaction) {
        step Contract::Persist()
        step :build_profile_params
        step :create_profile
      }
  }

  private

  def build_profile_params(options, params:, **)
    if options[:model].properties[:account_type] == 'admin'
      options[:profile_params] = { user_id: options[:model].id }
    else
      options[:profile_params] = params[:profile].merge(user_id: options[:model].id)
    end

    true
  end

  def create_profile(options, model:, **)
    result = User::Operation::CreateProfile.call(profile: options[:profile_params], model: model)

    raise User::CreateProfileError unless result.success?
    true
  end

  def assign_roles(options, params:, **)
    return true if params[:roles].nil?
    
    options[:model].roles = Role.where(id: params[:roles])
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
