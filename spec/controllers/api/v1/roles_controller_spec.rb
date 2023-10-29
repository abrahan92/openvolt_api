# spec/controllers/api/v1/roles_controller_spec.rb

RSpec.describe Api::V1::RolesController, type: :controller do
  shared_examples '403 action not allowed' do
    it 'returns a 403 status' do
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #index' do
    let!(:role) { create(:role) }
    
    it 'returns a 200 status and a list of roles' do
      get :index

      expect(response).to have_http_status(200)
      expect(json_response).to all(include({
        'id' => role.id,
        'name' => role.name
      }))
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
    context 'role exists' do
      let!(:role) { create(:role) }

      it 'returns the requested role' do
        get :show, params: { id: role.id }, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include('id' => role.id)
      end
    end

    context 'role does not exist' do
      it 'returns a 404 error' do
        get :show, params: { id: -1 }, as: :json

        expect(response).to have_http_status(404)
      end
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        get :show, params: { id: -1 }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'POST #create' do
    let!(:permission) { create(:permission) }
    let(:valid_params) do
      { name: 'other', description: 'Other role', permission_ids: [permission.id] }
    end

    it 'creates a role and returns a 200 status' do
      post :create, params: valid_params, as: :json

      expect(response).to have_http_status(200)
      expect(json_response).to include('name' => 'other')
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
    let(:new_name) { 'other' }

    it 'updates a role and returns a 200 status' do
      put :update, params: { id: role.id, name: new_name }, as: :json

      expect(response).to have_http_status(200)
      expect(json_response).to include('name' => new_name)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        put :update, params: { id: role.id, name: new_name }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'DELETE #destroy' do
    let!(:role) { create(:role, name: 'other' ) }

    it 'destroys a role and returns a 200 status' do
      delete :destroy, params: { id: role.id }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        delete :destroy, params: { id: role.id }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'POST #add_role_to_user' do
    let!(:role) { create(:role, name: 'other') }
    let!(:other_user) { create(:user, :other_profile) }

    it 'adds a role to a user and returns a 200 status' do
      post :add_role_to_user, params: { user_role: {
        role_id: role.id, user_id: user.id
      } }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        post :add_role_to_user, params: { user_role: {
          role_id: role.id, user_id: user.id
        } }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'DELETE #delete_role_from_user' do
    let!(:other_user) { create(:user, :other_profile) }
    let!(:new_role) { create(:role) }

    before do
      other_user.roles << new_role
    end

    it 'deletes a role from a user and returns a 200 status' do
      delete :delete_role_from_user, params: { user_role: {
        role_id: new_role.id, user_id: other_user.id
      } }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        delete :delete_role_from_user, params: { user_role: {
          role_id: new_role.id, user_id: other_user.id
        } }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end
end