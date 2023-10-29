# spec/controllers/api/v1/role_permissions_controller_spec.rb

RSpec.describe Api::V1::RolePermissionsController, type: :controller do
  shared_examples '403 action not allowed' do
    it 'returns a 403 status' do
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #index' do
    it 'returns a 200 status and a list of role_permissions' do
      get :index

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        get :index
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'GET #show' do
    let!(:role) { create(:role) }

    context 'role_permission exists' do
      it 'returns the requested role_permission' do
        get :show, params: { id: role.role_permissions.first.id }, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include({
          'role_id' => role.id,
          'permission_id' => role.role_permissions.first.permission_id
        })
      end

      context 'user is not an admin' do
        include_context 'doorkeeper_authentication', :other_profile

        before do
          get :show, params: { id: role.role_permissions.first.id }, as: :json
        end

        it_behaves_like '403 action not allowed'
      end
    end

    context 'role_permission does not exist' do
      it 'returns a 404 error' do
        get :show, params: { id: -1 }, as: :json

        expect(response).to have_http_status(404)
      end

      context 'user is not an admin' do
        include_context 'doorkeeper_authentication', :other_profile

        before do
          get :show, params: { id: -1 }, as: :json
        end

        it_behaves_like '403 action not allowed'
      end
    end
  end

  describe 'POST #create' do
    let!(:role) { create(:role) }
    let!(:new_permission) { create(:permission, subject: 'home', action_perform: 'update') }

    let(:valid_params) do
      {
        role_id: role.id,
        permission_id: new_permission.id,
      }
    end

    context 'valid parameters' do
      it 'creates a role_permission and returns a 200 status' do
        post :create, params: valid_params, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include({
          'role_id' => role.id,
          'permission_id' => new_permission.id
        })
      end
    end

    context 'invalid parameters' do
      it 'does not create a role_permission and returns a 404 status' do
        post :create, params: { role_id: nil }, as: :json

        expect(response).to have_http_status(404)
      end
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        post :create, params: valid_params, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'PUT #update' do
    let!(:role) { create(:role) }
    let!(:new_permission) { create(:permission, subject: 'home', action_perform: 'update') }

    it 'updates a role_permission and returns a 200 status' do
      put :update, params: { 
        id: role.role_permissions.first.id, permission_id: new_permission.id, role_id: role.id
      }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        put :update, params: { 
          id: role.role_permissions.first.id, permission_id: new_permission.id, role_id: role.id
        }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'DELETE #destroy' do
    let!(:role) { create(:role) }
    let!(:new_permission) { create(:permission, subject: 'home', action_perform: 'update') }

    before do
      role.permissions << new_permission
    end

    it 'destroys a role_permission and returns a 200 status' do
      delete :destroy, params: { id: role.role_permissions.first.id }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        delete :destroy, params: { id: role.role_permissions.first.id }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end
end