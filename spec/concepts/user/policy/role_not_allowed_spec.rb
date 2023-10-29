# spec/concepts/user/policy/role_not_allowed_spec.rb

RSpec.describe User::Policy::RoleNotAllowed do
    describe '.call' do
      let(:admin_role) { create(:role, name: 'admin') }
      let(:user_role) { create(:role, name: 'user') }
  
      context 'when role matches account_type' do
        it 'returns true' do
          result = described_class.call({}, params: { roles: admin_role.id, properties: { account_type: 'admin' } })
          expect(result).to be(true)
        end
      end
  
      context 'when role does not match account_type' do
        it 'returns false' do
          result = described_class.call({}, params: { roles: admin_role.id, properties: { account_type: 'other' } })
          expect(result).to be(false)
        end
      end
  
      context 'when role is not found' do
        it 'returns false' do
          result = described_class.call({}, params: { roles: -1, properties: { account_type: 'admin' } })
          expect(result).to be(false)
        end
      end
  
      context 'when an exception is raised' do
        it 'returns false' do
          allow(Role).to receive(:where).and_raise(StandardError)
          result = described_class.call({}, params: { roles: admin_role.id, properties: { account_type: 'admin' } })
          expect(result).to be(false)
        end
      end
    end
  end