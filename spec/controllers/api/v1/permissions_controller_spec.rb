# spec/controllers/api/v1/permissions_controller_spec.rb

RSpec.describe Api::V1::PermissionsController, type: :controller do
  shared_examples '403 action not allowed' do
    it 'returns a 403 status' do
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #index' do
    it 'returns a 200 status and a list of permissions' do
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
    let!(:permission) { create(:permission) }

    context 'permission exists' do
      it 'returns the requested permission' do
        get :show, params: { id: permission.id }, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include('id' => permission.id)
      end

      context 'user is not an admin' do
        include_context 'doorkeeper_authentication', :other_profile

        before do
          get :show, params: { id: permission.id }, as: :json
        end

        it_behaves_like '403 action not allowed'
      end
    end

    context 'permission does not exist' do
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
    let(:valid_params) do
      {
        subject: 'home',
        action_perform: 'update'
      }
    end

    context 'valid parameters' do
      it 'creates a permission and returns a 200 status' do
        post :create, params: valid_params, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include({
          'subject' => 'home',
          'action_perform' => 'update'
        })
      end
    end

    context 'invalid parameters' do
      it 'does not create a permission and returns a 422 status' do
        post :create, params: { subject: nil }, as: :json

        expect(response).to have_http_status(422)
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
    let!(:permission) { create(:permission) }
    let(:new_subject) { 'addresses' }

    it 'updates a permission and returns a 200 status' do
      put :update, params: { id: permission.id, subject: new_subject }, as: :json

      expect(response).to have_http_status(200)
      expect(json_response).to include({
        'subject' => new_subject
      })
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        put :update, params: { id: permission.id, subject: new_subject }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'DELETE #destroy' do
    let!(:permission) { create(:permission) }

    it 'destroys a permission and returns a 200 status' do
      delete :destroy, params: { id: permission.id }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        delete :destroy, params: { id: permission.id }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end
end