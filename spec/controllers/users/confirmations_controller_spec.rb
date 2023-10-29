# spec/controllers/users/confirmations_controller_spec.rb

RSpec.describe Users::ConfirmationsController, type: :controller do
  describe 'GET #show' do
    let(:application) { create(:oauth_application) }
    let(:user) { create(:user, :unconfirmed) }
    let(:confirmation_token) { user.confirmation_token }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.headers["Client-Id"] = application.uid
    end

    subject(:confirm) do
      get :show, params: { confirmation_token: confirmation_token }
    end

    context 'with a valid confirmation token' do
      before { confirm }

      it 'confirms the user' do
        expect(user.reload.confirmed?).to be_truthy
        expect(json_response['message']).to include("confirmed")
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with an invalid confirmation token' do
      let(:confirmation_token) { 'invalidtoken' }

      before { confirm }

      it 'does not confirm the user' do
        expect(json_response['message']).to include("not_confirmed")
        expect(response).to have_http_status(400)
      end
    end

    context 'with an already confirmed user' do
      let(:user) { create(:user, confirmed_at: Time.current) }

      before { confirm }

      it 'returns a confirmation failed message' do
        expect(json_response['message']).to include("not_confirmed")
        expect(response).to have_http_status(400)
      end
    end
  end
end