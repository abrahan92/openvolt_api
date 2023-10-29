# spec/concepts/user/policy/role_not_exist_spec.rb

RSpec.describe User::Policy::RoleNotExist do
    describe '.call' do
      let(:existing_role) { create(:role) }
      let(:another_existing_role) { create(:role, :other) }
  
      context 'when roles parameter is nil' do
        it 'returns true' do
          result = described_class.call({}, params: { roles: nil })
          expect(result).to be(true)
        end
      end
  
      context 'when all roles exist' do
        it 'returns true' do
          result = described_class.call({}, params: { roles: [existing_role.id, another_existing_role.id] })
          expect(result).to be(true)
        end
      end
  
      context 'when any role does not exist' do
        it 'returns false' do
          result = described_class.call({}, params: { roles: [existing_role.id, -1] })
          expect(result).to be(false)
        end
      end
  
      context 'when an ActiveRecord::RecordNotFound exception is raised' do
        it 'returns false' do
          allow(Role).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
          result = described_class.call({}, params: { roles: [existing_role.id] })
          expect(result).to be(false)
        end
      end
    end
  end