# spec/concepts/role/operation/show_spec.rb

RSpec.describe Role::Operation::Show do
  let!(:role) { create(:role) }
  let(:params) { { id: role.id } }

  subject(:result) { described_class.call(params) }

  context 'when given a valid id' do
    it 'retrieves the role' do
      expect(result).to be_success
      expect(result['model']).to eq(role)
    end
  end

  context 'when given an invalid id' do
    let(:params) { { id: -1 } }
    
    it 'does not retrieve any role' do
      expect(result).to be_failure
      expect(result['model']).to be_nil
    end
  end
end
