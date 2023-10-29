# spec/controllers/users_controller_spec.rb

RSpec.describe UsersController, type: :controller do
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

  describe 'POST #create' do
    context 'with valid parameters' do
      context 'when is new_other' do
        include_context "doorkeeper_authentication", :new_other
        include_context "with roles", :new_other

        let(:role_id) { user.roles.first.id }

        subject { post :create, params: params }

        it { expect(subject).to have_http_status(200) }

        it 'creates a new user' do
          expect { subject }.to change(User, :count).by(1)
        end

        it 'returns the created user' do
          subject
          expect(json_response).to include({
            "email" => params[:email]
          })
        end

        context 'when assigning a different role than property account_type' do
          before do
            user.roles.first.update(name: 'other')
          end

          it "doesn't create a new user" do
            expect { subject }.to_not change(User, :count)

            expect(json_response).to include({
              "success" => false,
              "key" => "role_not_allowed"
            })
          end
        end
      end

      context 'when is other' do
        include_context "doorkeeper_authentication", :other
        include_context "with roles", :other

        before do
          params[:properties][:account_type] = 'other'
          params[:profile] = {
            "birthdate": "1991-10-25",
            "phone_number": "12345678"
          }
        end

        let(:role_id) { user.roles.first.id }

        subject { post :create, params: params }

        it { expect(subject).to have_http_status(200) }

        it 'creates a new user' do
          expect { subject }.to change(User, :count).by(1)
        end

        it 'returns the created user' do
          subject
          expect(json_response).to include({
            "email" => params[:email]
          })
        end

        context 'when assigning a different role than property account_type' do
          before do
            user.roles.first.update(name: 'new_other')
          end

          it "doesn't create a new user" do
            expect { subject }.to_not change(User, :count)

            expect(json_response).to include({
              "success" => false,
              "key" => "role_not_allowed"
            })
          end
        end
      end
    end

    context 'with invalid parameters' do
      context "when profile is empty" do
        include_context "doorkeeper_authentication", :new_other
        include_context "with roles", :new_other

        let(:role_id) { user.roles.first.id }

        before do
          params[:profile] = {}
        end

        subject { post :create, params: params }

        it "doesn't create a new user" do
          expect { subject }.to_not change(User, :count)

          expect(json_response).to include({
            "success" => false,
            "key" => "record_invalid"
          })
        end
      end

      context "when have attributes that are not allowed" do
        include_context "doorkeeper_authentication", :new_other
        include_context "with roles", :new_other

        let(:role_id) { user.roles.first.id }

        before do
          params[:profile][:wrong_attribute] = "wrong_attribute"
        end

        subject { post :create, params: params }

        it "doesn't create a new user" do
          expect { subject }.to_not change(User, :count)

          expect(json_response).to match(
            "key" => "record_invalid",
            "success" => false,
            "data" => {
              "profile" => [
                "The property '#/' contains additional properties [\"wrong_attribute\"] outside of the schema when none are allowed"
              ]
            }
          )
        end
      end
    end
  end
end