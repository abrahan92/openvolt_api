class Api::V1::RolesController < ApiController
  before_action :action_just_allowed_for_admin_error

  def index
    endpoint Role::Operation::List do
      on_success { represent(Role::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def show
    endpoint Role::Operation::Show do
      on_success { represent(Role::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_not_found_error }
    end
  end

  def create
    endpoint Role::Operation::Create do
      on_success               { represent(Role::Representer::Default) }
      on_failed_contract       { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def update
    endpoint Role::Operation::Update do
      on_success         { represent(Role::Representer::Default) }
      on_failed_contract { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_not_found_error }
    end
  end

  def destroy
    endpoint Role::Operation::Delete do
      on_success { represent(Role::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_not_found_error }
    end
  end

  def add_role_to_user
    endpoint Role::Operation::AddRoleToUser do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_not_found_error }
    end
  end

  def delete_role_from_user
    endpoint Role::Operation::DeleteRoleToUser do
      on_success { represent(User::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { role_not_found_error }
    end
  end

  private

  def role_not_found_error
    defaultapi_error!(:role_not_found, "Role not found", 404)
  end

  def failed_contract_error
    record_invalid_error
  end
end