class Api::V1::PermissionsController < ApiController
  before_action :action_just_allowed_for_admin_error
  
  def index
    endpoint Permission::Operation::List do
      on_success { represent(Permission::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def show
    endpoint Permission::Operation::Show do
      on_success { represent(Permission::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { permission_not_found_error }
    end
  end

  def create
    endpoint Permission::Operation::Create do
      on_success               { represent(Permission::Representer::Default) }
      on_failed_contract       { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
    end
  end

  def update
    endpoint Permission::Operation::Update do
      on_success         { represent(Permission::Representer::Default) }
      on_failed_contract { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { permission_not_found_error }
    end
  end

  def destroy
    endpoint Permission::Operation::Delete do
      on_success { represent(Permission::Representer::Default) }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_model_not_found { permission_not_found_error }
    end
  end

  private

  def permission_not_found_error
    defaultapi_error!(:permission_not_found, "Permission not found", 404)
  end

  def failed_contract_error
    record_invalid_error
  end
end