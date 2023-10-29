# spec/concepts/permission/operation/list_spec.rb

RSpec.describe Permission::Operation::List, type: :operation do
  describe 'Call' do
    let!(:permission1) { create(:permission, action_perform: 'read', subject: 'home') }
    let!(:permission2) { create(:permission, action_perform: 'update', subject: 'home') }

    subject(:result) { described_class.call }

    it 'is successful' do
      expect(result).to be_success
    end

    it 'returns all permissions' do
      expect(result[:model]).to match_array([permission1, permission2])
    end
  end
end
