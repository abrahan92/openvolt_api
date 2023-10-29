RSpec.describe 'Doorkeeper JWT configuration', type: :request do
  context 'when user is a other' do
    let(:new_user) { create(:other).user }
    let(:application) { create(:oauth_application) }

    shared_examples "validate token" do
      it "returns a valid token" do
        expect(response).to have_http_status(:success)
        expect(access_token).to be_present
        expect(refresh_token).to be_present
        expect(expires_in).to be_present
        expect(token_type).to eq('Bearer')
        expect(expires_in).to eq(172800.seconds.to_i)
        expect(payload['iss']).to eq('DefaultApi App')
        expect(payload['user']).to eq(
          User::Representer::DoorkeeperUser.new(new_user.reload).as_json
        )
      end
    end

    shared_context "token for user" do
      before do
        post '/oauth/token', params: {
          grant_type: 'password',
          email: new_user.email,
          password: new_user.password,
          client_id: application.uid,
          client_secret: application.secret
        }
      end

      let(:json_response) { JSON.parse(response.body) }
      let(:access_token) { json_response['access_token'] }
      let(:expires_in) { json_response['expires_in'] }
      let(:refresh_token) { json_response['refresh_token'] }
      let(:token_type) { json_response['token_type'] }
      let(:decoded_token) { JWT.decode(access_token, nil, false) }
      let(:payload) { decoded_token.first }

      it_behaves_like "validate token"
    end

    context "validate token for admin" do
      include_context "token for user"

      let(:new_user) { create(:admin).user }

      it "returns a token for admin" do
        expect(payload['user']['properties']['account_type']).to eq('admin')
        expect(payload['user']['profile']).to eq(
          Profile::Representer::Admin.new(new_user.reload.admin).as_json
        )
      end
    end
  end
end