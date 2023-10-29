# spec/requests/sessions_spec.rb

RSpec.describe CustomTokensController, type: :request do

  let(:user) { create(:user, email: "test@example.com", password: "password") }
  let(:application) { create(:oauth_application) } # Doorkeeper's Application
  let(:token) { Doorkeeper::AccessToken.create!(
    resource_owner_id: user.id,
    application: application,
    scopes: "read",
    refresh_token: "1234567890",
    expires_in: 1.hour
    ) }
  let(:other) { create(:new_other, user: user) }

  shared_examples "a secure cookie" do |cookie_name|
    let(:cookie) { extract_cookies(cookie_name) }

    # verify the cookie is set with the HttpOnly attribute. This makes it 
    # harder for malicious scripts to access the token.
    it 'sets HttpOnly for access_token' do
      expect(cookie).to include('HttpOnly')
    end

    # verify that the cookie is only sent in requests originating 
    # from the same site. This can prevent cross-site request forgery attacks.
    it 'sets SameSite=Strict for access_token' do
      expect(cookie).to include('SameSite=Strict')
    end

    # If your application is deployed over HTTPS (which it should be for 
    # any production application dealing with authentication), ensure that 
    # you also set the Secure attribute for your cookies. This ensures the 
    # cookie is only sent over secure connections.
    # it 'sets Secure for access_token' do
    #   expect(cookie).to include('secure')
    # end
  end

  describe "POST #create" do
    context "with valid credentials" do
      before do
        post oauth_token_path, params: { 
          email: user.email,
          password: 'password',
          grant_type: 'password',
          client_id: application.uid,
          client_secret: application.secret
        }
      end

      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end

      it "returns the correct tokens" do
        expect(json_response.keys).to include(
          "access_token", "token_type", "expires_in", "refresh_token", "scope", "created_at"
        )
      end

      context "defaultapi_access_token cookie" do
        it_behaves_like "a secure cookie", 'defaultapi_access_token'
      end
      
      context "defaultapi_refresh_token cookie" do
        it_behaves_like "a secure cookie", 'defaultapi_refresh_token'
      end
    end

    context "with invalid credentials" do
      before do
        post oauth_token_path, params: { 
          email: user.email,
          password: 'wrong_password',
          grant_type: 'password',
          client_id: application.uid,
          client_secret: application.secret
        }
      end

      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end

      it "returns the correct error" do
        expect(json_response["error"]).to eq("invalid_grant")
        expect(json_response["error_description"]).to match(/The provided authorization grant is invalid, expired, revoked/)
      end
    end
  end

  describe "POST #refresh" do
    context "with valid credentials" do
      before do
        post oauth_token_path, params: {
          grant_type: 'refresh_token',
          client_id: application.uid,
          client_secret: application.secret,
          refresh_token: token.refresh_token
        }
      end

      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end

      it "returns the correct tokens" do
        expect(json_response.keys).to include(
          "access_token", "token_type", "expires_in", "refresh_token", "scope", "created_at"
        )
      end

      context "defaultapi_access_token cookie" do
        it_behaves_like "a secure cookie", 'defaultapi_access_token'
      end

      context "defaultapi_refresh_token cookie" do
        it_behaves_like "a secure cookie", 'defaultapi_refresh_token'
      end

      context "when the refresh token is revoked" do
        before do
          token.revoke
          post oauth_token_path, params: {
            grant_type: 'refresh_token',
            client_id: application.uid,
            client_secret: application.secret,
            refresh_token: token.refresh_token
          }
        end

        it "returns a 400 status" do
          expect(response).to have_http_status(400)
        end

        it "returns the correct error" do
          expect(json_response["error"]).to eq("invalid_grant")
          expect(json_response["error_description"]).to match(/The provided authorization grant is invalid, expired, revoked/)
        end
      end

      context "when the refresh token is expired" do
        before do
          token.update_attribute(:expires_in, -1)
          post oauth_token_path, params: {
            grant_type: 'refresh_token',
            client_id: application.uid,
            client_secret: application.secret,
            refresh_token: token.refresh_token
          }
        end

        it "returns a 400 status" do
          expect(response).to have_http_status(400)
        end

        it "returns the correct error" do
          expect(json_response["error"]).to eq("invalid_grant")
          expect(json_response["error_description"]).to match(/The provided authorization grant is invalid, expired, revoked/)
        end
      end
      
      context "when the refresh token is not present" do
        before do
          post oauth_token_path, params: {
            grant_type: 'refresh_token',
            client_id: application.uid,
            client_secret: application.secret
          }
        end

        it "returns a 400 status" do
          expect(response).to have_http_status(400)
        end

        it "returns the correct error" do
          expect(json_response["error"]).to eq("invalid_request")
          expect(json_response["error_description"]).to match(/Missing required parameter: refresh_token/)
        end
      end
    end
  end


  describe "DELETE #revoke" do
    context "when token is valid and not revoked" do
      before do
        post oauth_revoke_path , params: { 
          client_id: application.uid,
          client_secret: application.secret
        }, headers: { 'Authorization' => "Bearer #{token.token}" }
      end
      
      it "revokes the token and responds with 200" do
        expect(response.status).to eq(200)
        expect(token.reload.revoked?).to be_truthy
        expect(json_response['success']).to be_truthy
      end
    end

    context "when token is already revoked" do
      before do
        token.revoke

        post oauth_revoke_path , params: { 
          client_id: application.uid,
          client_secret: application.secret
        }, headers: { 'Authorization' => "Bearer #{token.token}" }
      end
      
      it "revokes the token and responds with 200" do
        expect(response.status).to eq(400)
        expect(json_response['key']).to eq('something_went_wrong')
      end
    end
  end
end