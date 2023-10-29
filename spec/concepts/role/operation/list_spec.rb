# spec/concepts/role/operation/list_spec.rb

RSpec.describe Role::Operation::List, type: :operation do
  describe 'Call' do
    let!(:role1) { create(:role, name: 'read') }
    let!(:role2) { create(:role, name: 'list') }

    subject(:result) { described_class.call }

    it 'is successful' do
      expect(result).to be_success
    end

    it 'returns all roles' do
      expect(result[:model]).to match_array([role1, role2])
    end
  end
end
