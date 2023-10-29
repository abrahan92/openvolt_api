class Api::V1::RolePermissionsController < ApiController
  before_action :action_just_allowed_for_admin_error
  
  def index
    endpoint RolePermission::Operation::List do
      on_success { represent(RolePermission::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def show
    endpoint RolePermission::Operation::Show do
      on_success { represent(RolePermission::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_permission_not_found_error }
    end
  end

  def create
    endpoint RolePermission::Operation::Create do
      on_success               { represent(RolePermission::Representer::Default) }
      on_failed_contract       { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:role_and_permission_must_exists) { role_permission_policy_error }
    end
  end

  def update
    endpoint RolePermission::Operation::Update do
      on_success         { represent(RolePermission::Representer::Default) }
      on_failed_contract { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_permission_not_found_error }
      on_failed_policy(:role_and_permission_must_exists) { role_permission_policy_error }
    end
  end

  def destroy
    endpoint RolePermission::Operation::Delete do
      on_success { represent(RolePermission::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_permission_not_found_error }
    end
  end

  private

  def role_permission_not_found_error
    defaultapi_error!(:role_permission_not_found, "Role Permission not found", 404)
  end

  def role_permission_policy_error
    defaultapi_error!(:role_permission_must_exists, "Role and Permission must exist", 404)
  end

  def failed_contract_error
    record_invalid_error
  end
end