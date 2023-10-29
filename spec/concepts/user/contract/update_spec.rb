# spec/user/contract/update_password_spec.rb

# spec/concepts/user/contract/update_spec.rb
require 'rails_helper'

RSpec.describe User::Contract::Update do
  let(:user) { create(:user, :new_other_profile) }
  let(:role) { create(:role, :new_other) }
  let(:contract) { described_class.new(user) }
  let(:params) do
    {
      "name": "Ramon Kozey",
      "lastname": "Boehm",
      "password": "12345678",
      "roles": [role.id],
      "properties": {
          "platform_access": "mobile",
          "account_type": "new_other"
      },
      "profile": {
          "birthdate": "1991-10-25",
          "phone_number": "12345678"
      }
    }
  end

  describe 'validations' do
    context 'when valid params' do
      before { contract.validate(params) }

      it { expect(contract).to be_valid }
      
      it 'does not have errors' do
        expect(contract.errors.messages).to be_empty
      end
    end

    context 'validate properties fields' do
      context 'when invalid properties' do
        before do
          params[:properties] = {
            platform_access: 'invalid_access',
            account_type: 'invalid_account'
          }
          contract.validate(params)
        end

        it 'is invalid' do
          expect(contract.errors.messages[:properties]).to include("The property '#/platform_access' value \"invalid_access\" did not match one of the following values: backoffice, web, mobile")
          expect(contract.errors.messages[:properties]).to include("The property '#/account_type' value \"invalid_account\" did not match one of the following values: super_admin, admin, new_other, other")
        end
      end
    end
  end
end