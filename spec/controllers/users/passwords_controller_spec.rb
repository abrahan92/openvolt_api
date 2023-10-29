# spec/controllers/users/passwords_controller_spec.rb

RSpec.describe Users::PasswordsController, type: :controller do
  let(:user) { create(:user) }
  let(:application) { create(:oauth_application) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    before do
      post :create, params: { email: user.email }
    end

    context "when email is registered and has no provider" do
      it "sends the email with reset password instructions" do
        expect(response).to have_http_status(200)
        expect(json_response['message']).to include("email_sent")
      end
    end

    context "when email couldn't be sent" do
      before do
        allow_any_instance_of(User).to receive(:send_reset_password_instructions).and_return(false)
        post :create, params: { email: user.email }
      end

      it "returns an error" do
        expect(response).to have_http_status(400)
        expect(json_response['message']).to eq('email_not_sent')
      end
    end

    context "when email is unregistered" do
      before do
        post :create, params: { email: "unregistered@example.com" }
      end

      it "returns an unregistered email error" do
        expect(response).to have_http_status(400)
        expect(json_response['message']).to eq('email_not_sent')
      end
    end
  end

  describe 'PUT #update' do
    let(:reset_password_token) { user.reset_password_token }
    let(:password) { "NewPassword123!" }
    let(:password_confirmation) { "NewPassword123!" }

    before do
      user.send_reset_password_instructions
    end

    subject(:update) do
      put :update, params: { reset_password_token: reset_password_token, password: password, password_confirmation: password_confirmation }
    end

    context "with valid password and token" do
      before { update }

      it "resets the user's password" do
        expect(user.reload.valid_password?(password)).to be true
      end

      it "confirms the user if they aren't already" do
        expect(user.reload.confirmed?).to be true
      end

      it "returns success message" do
        expect(response).to have_http_status(200)
        expect(json_response['message']).to eq("password_updated")
      end
    end

    context "when reset password token is invalid" do
      let(:reset_password_token) { "invalid_token" }

      before { update }

      it "returns an error because user is not found" do
        expect(response).to have_http_status(400)
        expect(json_response['message']).to match(/undefined method `reset_password' for nil:NilClass/)
      end
    end

    context "when password doesn't match password confirmation" do
      let(:password_confirmation) { "AnotherPassword123!" }

      before { update }
      
      it "returns an error" do
        expect(response).to have_http_status(400)
        expect(json_response['message']).to eq("passwords_do_not_match")
      end
    end

    context "when unable to update the user's password" do
      before do
        allow_any_instance_of(User).to receive(:reset_password).and_return(false)

        put :update, params: { reset_password_token: reset_password_token, password: password, password_confirmation: password_confirmation }
      end

      it "returns an error" do
        expect(response).to have_http_status(400)
        expect(json_response['message']).to eq("password_not_updated")
      end
    end

    context "when passwords are blank" do
      let(:password) { "" }
      let(:password_confirmation) { "" }

      before { update }

      it "returns an error" do
        expect(response).to have_http_status(400)
        expect(json_response['message']).to eq("password_not_updated")
      end
    end
  end
end