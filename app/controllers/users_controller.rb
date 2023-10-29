# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: %i[create]
  before_action :assign_request_from, only: [:create]

  def create
    endpoint User::Operation::BaseCreate do
      on_success               { represent(User::Representer::Default) }
      on_failed_contract       { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:email_is_available) { email_already_exist_policy_error }
      on_failed_policy(:role_not_exist) { role_not_exist_policy_error }
      on_failed_policy(:passwords_match) { passwords_doesnt_match_error }
      on_failed_policy(:roles_count_must_be_one) { roles_user_must_be_just_one_policy_error }
      on_failed_policy(:profile_params_required) { profile_params_required_policy_error }
      on_failed_policy(:user_not_allowed_sign_up) { user_not_allowed_sign_up_policy_error }
      on_failed_policy(:role_not_allowed) { role_not_allowed_policy_error }
    end
  end

  private

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

  def user_not_allowed_sign_up_policy_error
    defaultapi_error!(:user_not_allowed_sign_up, "User not allowed sign up", 403)
  end

  def role_not_allowed_policy_error
    defaultapi_error!(:role_not_allowed, "Role not allowed to this user", 403)
  end
end