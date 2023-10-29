# spec/concepts/user/operation/update_spec.rb

RSpec.describe User::Operation::Update do
  describe 'call' do
    let!(:user) { create(:user, :new_other_profile) }
    let!(:role) { create(:role, :new_other) }
    let(:new_name) { Faker::Name.first_name }
    let(:params) do
      {
        "id": user.id,
        "name": new_name,
        "profile": {
          "phone_number": Faker::PhoneNumber.cell_phone
        },
        "properties": {
          "account_type": "new_other",
          "platform_access": "mobile",
          "customer_stripe_identifier": "cus_123456789"
        }
      }
    end

    before do
      RSpec.configuration.current_user = user
      user.roles << role
    end

    subject(:result) { described_class.call(params) }

    context 'when the user exists' do
      context 'when the params are valid' do
        it 'updates the user' do
          expect(result.success?).to be_truthy
          expect(result[:model].name).to eq(new_name)
        end

        context "updating the profile" do
          before do
            params.merge!(profile: { phone_number: Faker::PhoneNumber.cell_phone })
          end

          it "update the phone number" do
            expect(result.success?).to be_truthy
            expect(result[:model].profile.phone_number).to eq(params[:profile][:phone_number])
          end

          it "calls the UpdateProfile operation" do
            expect(User::Operation::UpdateProfile).to receive(:call).and_call_original
            result
          end
        end
      end

      context 'when the params are invalid' do
        context "when role is not allowed" do
          let(:role) { create(:role) }

          before do
            params[:roles] = [role.id]
          end

          it 'fails the policy' do
            expect(result).to fail_a_policy("role_not_allowed")
          end
        end

        context "when the role does not exist" do
          before do
            params[:roles] = [9999]
          end

          it 'fails the policy' do
            expect(result).to fail_a_policy("role_not_exist")
          end
        end

        context "when the passwords do not match" do
          before do
            params[:password] = '123456'
            params[:password_confirmation] = '1234567'
          end

          it 'fails the policy' do
            expect(result).to fail_a_policy("passwords_match")
          end
        end

        context "when the roles count is not one" do
          before do
            params[:roles] = [1, 2]
          end

          it 'fails the policy' do
            expect(result).to fail_a_policy("roles_count_must_be_one")
          end
        end
      end

      context 'when the user is not allowed to update the user' do
        before do
          RSpec.configuration.current_user = create(:other).user
        end

        it 'fails the policy' do
          expect(result).to fail_a_policy("user_can_update_user")
        end
      end

      context 'when the user is admin and is allowed to update the user' do
        before do
          RSpec.configuration.current_user = create(:admin).user
        end
        
        it 'updates the user' do
          expect(result.success?).to be_truthy
          expect(result[:model].name).to eq(new_name)
        end
      end
    end

    context 'when the user does not exist' do
      let(:params) do
        {
          id: 9999,
          name: new_name,
        }
      end

      it 'returns a failure' do
        expect(result.failure?).to be_truthy
      end
    end
  end
end
