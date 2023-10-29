class Role::Operation::DeleteRoleToUser < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step :verify_user_and_role
    step :delete_role_to_user
  }

  private

  def verify_user_and_role(options, params:, **)
    @user = User.find_by(id: params[:user_role][:user_id])
    @role = Role.find_by(id: params[:user_role][:role_id])

    return true if @user.present? && @role.present?

    raise Role::UserOrRoleNotFound
  end

  def delete_role_to_user(options, **)
    user_role = UserRole.where(user_id: @user.id, role_id: @role.id)

    raise Role::UserRoleNotFound if user_role.blank?

    options[:model] = @user

    user_role.delete_all
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
