# spec/concepts/user/operation/base_create_spec.rb

RSpec.describe User::Operation::BaseCreate, type: :operation do
  describe 'call' do
    let!(:role) { create(:role, :new_other) }
    let(:params) do
      {
        "name": Faker::Name.first_name,
        "lastname": Faker::Name.last_name,
        "email": Faker::Internet.email,
        "password": "12345678",
        "password_confirmation": "12345678",
        "properties": {
            "platform_access": "mobile",
            "account_type": "new_other"
        },
        "roles": [role.id],
        "profile": {
            "birthdate": "1991-10-25",
            "phone_number": "12345678"
        }
      }
    end
    
    subject(:result) { described_class.call(params) }

    context 'when params are valid' do
      it 'creates a user' do
        expect(result.success?).to eq(true)
      end

      it 'creates the user' do
        expect { result }.to change(User, :count).by(1)
      end

      it 'call operation to create profile' do
        expect(User::Operation::CreateProfile).to receive(:call).and_call_original
        result
      end

      it 'creates the profile' do
        expect(result[:model].profile).to be_present
      end
    end

    context 'when params are invalid' do
      context 'when email is not present' do
        before do
          params.delete(:email)
        end

        it 'fail contract email' do
          expect(result).to fail_a_contract
        end
      end

      context 'when email is already taken' do
        before do
          create(:user, :new_other, email: params[:email])
        end

        it 'fail policy email_is_available' do
          expect(result).to fail_a_policy(:email_is_available)
        end
      end

      context 'when assigning more than one role' do
        before do
          params[:roles] = [role.id, role.id]
        end

        it 'fail policy roles_count_must_be_one' do
          expect(result).to fail_a_policy(:roles_count_must_be_one)
        end
      end

      context 'when role does not exist' do
        before do
          params[:roles] = [0]
        end

        it 'fail policy role_not_exist' do
          expect(result).to fail_a_policy(:role_not_exist)
        end
      end
      
      context 'when passwords do not match' do
        before do
          params[:password_confirmation] = '123456789'
        end

        it 'fail policy passwords_match' do
          expect(result).to fail_a_policy(:passwords_match)
        end
      end

      context 'when user is not allowed to sign up' do
        before do
          params[:properties][:account_type] = 'admin'
        end

        it 'fail policy user_not_allowed_sign_up' do
          expect(result).to fail_a_policy(:user_not_allowed_sign_up)
        end
      end

      context 'when role is not allowed' do
        before do
          role.destroy
          params[:roles] = [create(:role, :other).id]
        end

        it 'fail policy role_not_allowed' do
          expect(result).to fail_a_policy(:role_not_allowed)
        end
      end

      context 'raise error' do
        before do
          allow(User::Operation::CreateProfile).to receive(:call).and_raise(StandardError)
        end

        it 'fail rescue' do
          expect(result).to be_failure
        end
      end
    end
  end
end