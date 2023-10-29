# spec/concepts/user/contract/create_spec.rb

require 'rails_helper'

RSpec.describe User::Contract::Create, type: :model do
  let(:contract) { described_class.new(User.new) }
  let(:params) do
    {
      "email": "newtest17@test.com",
      "name": "Ramon Kozey",
      "lastname": "Boehm",
      "password": "12345678",
      "roles": [1],
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

      it 'not have errors' do
        expect(contract.errors.messages).to be_empty
      end
    end

    context 'when missing required fields' do
      before do
        params = {}
        contract.validate(params)
      end

      it 'is invalid' do
        expect(contract.errors.messages.keys).to include(:email, :password, :name, :lastname, :properties, :roles, :profile)
      end
    end

    context 'validate properties fields' do
      context 'when missing required properties fields' do
        before do
          params[:properties] = {}
          contract.validate(params)
        end

        it 'is invalid' do
          expect(contract.errors.messages[:properties]).to include('must be filled')
        end
      end

      context 'when properties are invalid' do
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

      context 'when missing properties' do
        context 'when missing platform_access' do
          before do
            params[:properties].delete(:platform_access)
            contract.validate(params)
          end

          it 'is invalid' do
            expect(contract.errors.messages[:platform_access]).to include("The property '#/' did not contain a required property of 'platform_access'")
          end
        end

        context 'when missing account_type' do
          before do
            params[:properties].delete(:account_type)
            contract.validate(params)
          end

          it 'is invalid' do
            expect(contract.errors.messages[:account_type]).to include("The property '#/' did not contain a required property of 'account_type'")
          end
        end
      end
    end

    context 'validate roles' do
      context 'when roles are invalid' do
        before do
          params[:roles] = "invalid_roles"
          contract.validate(params)
        end
  
        it 'is invalid' do
          expect(contract.errors.messages[:roles]).to include("must be an array")
        end
      end

      context 'when roles are missing' do
        before do
          params[:roles] = nil
          contract.validate(params)
        end
  
        it 'is invalid' do
          expect(contract.errors.messages[:roles]).to include("must be filled")
        end
      end
    end

    context 'validate profile' do
      context 'when profile is invalid' do
        before do
          params[:profile][:birthdate] = [1]
          contract.validate(params)
        end
  
        it 'is invalid' do
          expect(contract.errors.messages[:profile]).to include("The property '#/birthdate' of type array did not match the following type: string")
        end
      end
  
      context 'when profile is empty' do
        before do
          params[:profile] = {}
          contract.validate(params)
        end
  
        it 'is invalid' do
          expect(contract.errors.messages[:profile]).to include("must be filled")
        end
      end
    end
  end
end
