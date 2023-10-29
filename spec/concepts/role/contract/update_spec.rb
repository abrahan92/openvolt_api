# spec/concepts/role/contract/update_spec.rb

RSpec.describe Role::Contract::Update do
  let(:role) { create(:role) }
  let(:new_permission) { create(:permission, subject: 'home', action_perform: 'update') }

  let(:params) {
    {
      name: 'admin',
      permission_ids: [new_permission.id]
    }
  }

  subject(:contract) { described_class.new(role) }

  describe 'Validations' do
    context 'when all attributes are valid' do
      it 'is valid' do
        contract.validate(params)
        expect(contract).to be_valid
      end
    end

    context 'when name is not included in the allowed list' do
      it 'is invalid' do
        params[:name] = 'invalid_name'
        contract.validate(params)
        expect(contract).not_to be_valid
      end
    end
  end
end