class User::Operation::Update < Trailblazer::Operation
  self["contract.default.class"] = User::Contract::Update

  step Rescue(handler: :handler_error) {
    step Policy::Guard(User::Policy::UserCanUpdateUser, name: "user_can_update_user")
    step Model(User, :find_by)
    step Policy::Guard(User::Policy::RolesCountMustBeOne, name: "roles_count_must_be_one")
    step Policy::Guard(User::Policy::RoleNotExist, name: "role_not_exist")
    step Policy::Guard(User::Policy::PasswordsMatch, name: "passwords_match")
    step Policy::Guard(User::Policy::RoleNotAllowed, name: "role_not_allowed")
    step :assign_roles
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
    step :build_profile_params
    step :update_profile
  }

  private

  def build_profile_params(options, params:, **)
    return true if params[:picture].present? || params[:profile].blank?

    if options[:model].properties[:account_type] == 'admin'
      options[:profile_params] = { user_id: options[:model].id }
    else
      options[:profile_params] = params[:profile].merge(user_id: options[:model].id)
    end

    true
  end

  def update_profile(options, params:, model:, **)
    return true if params[:picture].present? || params[:profile].blank?

    result = User::Operation::UpdateProfile.call(profile: options[:profile_params], model: model)

    raise User::UpdateProfileError unless result.success?
    true
  end

  def assign_roles(options, params:, **)
    return true if params[:picture].present? || params[:roles].nil?
    
    options[:model].roles = Role.where(id: params[:roles])
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
