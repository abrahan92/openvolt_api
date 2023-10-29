# spec/concepts/api/v1/users_controller_spec.rb

RSpec.describe Api::V1::UsersController, type: :controller do
  shared_examples '403 action not allowed' do
    it 'returns a 403 status' do
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #index' do
    it 'returns a 200 status and a list of users' do
      get :index

      expect(response).to have_http_status(200)
      expect(json_response).to all(include({
        'id' => user.id,
        'email' => user.email
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

  describe 'GET #list' do
    it 'returns a 200 status and a list of users' do
      get :list

      expect(response).to have_http_status(200)
      expect(json_response).to all(include({
        'id' => user.id,
        'email' => user.email
      }))
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        get :list
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'GET #show' do
    context 'user exists' do
      let!(:user) { create(:user, :other_profile) }

      it 'returns the requested user' do
        get :show, params: { id: user.id }, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include({
          'id' => user.id,
          'email' => user.email
        })
      end
    end

    context 'user does not exist' do
      it 'returns a 404 error' do
        get :show, params: { id: -1 }, as: :json

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #show_me' do
    it 'returns the current user' do
      get :show_me

      expect(response).to have_http_status(200)
      expect(json_response).to include({
        'id' => user.id,
        'email' => user.email
      })
    end
  end

  describe 'POST #create' do
    let(:role_id) { create(:role).id }
    let(:params) do
      {
        "name": Faker::Name.name,
        "lastname": Faker::Name.last_name,
        "email": Faker::Internet.email,
        "password": "12345678",
        "password_confirmation": "12345678",
        "properties": {
            "platform_access": "mobile",
            "account_type": "new_other"
        },
        "roles": [role_id],
        "profile": {
            "birthdate": "1991-10-25",
            "phone_number": "12345678"
        }
      }
    end

    context 'valid parameters' do
      it 'creates a user and returns a 200 status' do
        post :create, params: params, as: :json

        expect(response).to have_http_status(200)
        expect(json_response).to include({
          "email" => params[:email]
        })
      end
    end

    context 'invalid parameters' do
      before do
        params[:email] = nil
      end

      it 'does not create a user and returns a 422 status' do
        post :create, params: params, as: :json

        expect(response).to have_http_status(422)
      end
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        post :create, params: params, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'PUT #update' do
    let(:params) do
      {
        "name": Faker::Name.name,
        "properties": {
          "platform_access": "mobile",
          "account_type": "new_other",
          "customer_stripe_identifier": "cus_123456789"
        }
      }
    end

    it 'updates a user and returns a 200 status' do
      put :update, params: { id: user.id, **params }, as: :json

      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT #update_password' do
    let(:params) do
      {
        "current_password": "12345678",
        "password": "123123123",
        "password_confirmation": "123123123"
      }
    end

    it 'updates the password and returns a 200 status' do
      put :update_password, params: { id: user.id, **params }, as: :json

      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE #destroy' do
    let!(:new_user) { create(:user, :other_profile) }

    it 'destroys a user and returns a 200 status' do
      delete :destroy, params: { id: new_user.id }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        delete :destroy, params: { id: new_user.id }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end
  end
  
  describe 'GET #send_user_confirmation' do
    let!(:new_user) { create(:user, :other_profile) }

    it 'sends a confirmation email and returns a 200 status' do
      get :send_user_confirmation, params: { id: new_user.id }, as: :json

      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #confirm_user' do
    let!(:new_user) { create(:user, :other_profile, :unconfirmed) }

    it 'confirms the user and returns a 200 status' do
      get :confirm_user, params: { id: new_user.id, confirmation_token: new_user.confirmation_token }, as: :json

      expect(response).to have_http_status(200)
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        get :confirm_user, params: { id: new_user.id, confirmation_token: new_user.confirmation_token }, as: :json
      end

      it_behaves_like '403 action not allowed'
    end

    context 'user is already confirmed' do
      let!(:new_user) { create(:user, :other_profile) }

      it 'returns a 422 status' do
        get :confirm_user, params: { id: new_user.id, confirmation_token: new_user.confirmation_token }, as: :json
        
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET #list_others' do
    let!(:other) { create(:other) }

    it 'returns a 200 status and a list of others' do
      get :list_others

      expect(response).to have_http_status(200)
      expect(json_response).to be_an(Array)
      expect(json_response).to include(hash_including({
        'id' => other.id
      }))
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        get :list_others
      end

      it_behaves_like '403 action not allowed'
    end
  end

  describe 'GET #list_new_others' do
    let!(:new_other) { create(:new_other) }

    it 'returns a 200 status and a list of health professionals' do
      get :list_new_others

      expect(response).to have_http_status(200)
      expect(json_response).to be_an(Array)
      expect(json_response).to include(hash_including({
        'id' => new_other.id
      }))
    end

    context 'user is not an admin' do
      include_context 'doorkeeper_authentication', :other_profile

      before do
        get :list_new_others
      end

      it_behaves_like '403 action not allowed'
    end
  end
end
