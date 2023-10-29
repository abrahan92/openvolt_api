class Api::V1::UsersController < ApiController
  def me
    endpoint User::Operation::ShowMe do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def index
    endpoint User::Operation::List do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  def list
    endpoint User::Operation::List do
      on_success { represent(User::Representer::List) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  def show
    endpoint User::Operation::Show do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { user_not_found_error }
      on_failed_policy(:action_allowed_for_user) { action_not_allowed_for_user_error }
    end
  end

  def show_me
    endpoint User::Operation::ShowMe do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def create
    endpoint User::Operation::Create do
      on_success               { represent(User::Representer::Default) }
      on_failed_contract       { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:email_is_available) { email_already_exist_policy_error }
      on_failed_policy(:role_not_exist) { role_not_exist_policy_error }
      on_failed_policy(:passwords_match) { passwords_doesnt_match_error }
      on_failed_policy(:roles_count_must_be_one) { roles_user_must_be_just_one_policy_error }
      on_failed_policy(:profile_params_required) { profile_params_required_policy_error }
      on_failed_policy(:role_not_allowed) { role_not_allowed_policy_error }
      on_failed_policy(:user_can_create_user) { user_cannot_create_user_error }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  def update
    endpoint User::Operation::Update do
      on_success         { represent(User::Representer::Default) }
      on_failed_contract { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { user_not_found_error }
      on_failed_policy(:role_not_exist) { role_not_exist_policy_error }
      on_failed_policy(:passwords_match) { passwords_doesnt_match_error }
      on_failed_policy(:roles_count_must_be_one) { roles_user_must_be_just_one_policy_error }
      on_failed_policy(:role_not_allowed) { role_not_allowed_policy_error }
      on_failed_policy(:user_can_update_user) { user_cannot_update_user_error }
    end
  end

  def update_password
    endpoint User::Operation::UpdatePassword do
      on_success         { represent(User::Representer::Default) }
      on_failed_contract { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { user_not_found_error }
      on_failed_policy(:passwords_match) { passwords_doesnt_match_error }
    end
  end

  def destroy
    endpoint User::Operation::Delete do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { user_not_found_error }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  def send_user_confirmation
    endpoint User::Operation::SendConfirmation do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { user_not_found_error }
      on_failed_policy(:action_allowed_for_user) { action_not_allowed_for_user_error }
    end
  end

  def confirm_user
    endpoint User::Operation::ConfirmUser do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { user_not_found_error }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  def list_others
    endpoint User::Operation::ListOthers do
      on_success { represent(User::Representer::ListOthers) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  def list_new_others
    endpoint User::Operation::ListNewOthers do
      on_success { represent(User::Representer::ListNewOthers) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:action_allowed_for_admin) { action_just_allowed_for_admin_error }
    end
  end

  private

  def passwords_doesnt_match_error
    defaultapi_error!(:passwords_doesnt_match, "Passwords doesn't match", 403)
  end

  def user_not_found_error
    defaultapi_error!(:user_not_found, "User not found", 404)
  end

  def failed_contract_error
    record_invalid_error
  end

  def email_already_exist_policy_error
    defaultapi_error!(:email_already_exist, "Email already exist", 403)
  end

  def role_not_exist_policy_error
    defaultapi_error!(:role_not_exist, "Role not exist", 403)
  end

  def must_be_super_admin_policy_error
    defaultapi_error!(:must_be_super_admin, "Just super admin could confirm a user manually", 403)
  end

  def roles_user_must_be_just_one_policy_error
    defaultapi_error!(:roles_user_must_be_just_one, "Roles user must one and is required", 403)
  end

  def profile_params_required_policy_error
    defaultapi_error!(:profile_params_required, "Profile params required", 403)
  end

  def role_not_allowed_policy_error
    defaultapi_error!(:role_not_allowed, "Role not allowed to this user", 403)
  end

  def user_cannot_create_user_error
    defaultapi_error!(:user_cannot_create_user, "User cannot create user", 403)
  end

  def user_cannot_update_user_error
    defaultapi_error!(:user_cannot_update_user, "User cannot update user", 403)
  end

  def action_not_allowed_for_user_error
    defaultapi_error!(:action_not_allowed_for_user, "Action not allowed for user", 403)
  end

  def action_just_allowed_for_admin_error
    defaultapi_error!(:action_just_allowed_for_admin, "Action just allowed for admin", 403)
  end
end