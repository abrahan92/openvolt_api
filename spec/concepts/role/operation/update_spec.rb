# spec/concepts/role/operation/update_spec.rb

RSpec.describe Role::Operation::Update do
  let!(:role) { create(:role) }
  let!(:new_permission) { create(:permission, subject: 'home', action_perform: 'update' ) }
  let(:params) do
    {
      id: role.id,
      name: 'other',
      permission_ids: [role.permissions.first.id, new_permission.id]
    }
  end

  subject(:result) { described_class.call(params) }

  context 'with valid parameters' do
    it 'updates just the role name' do
      expect(result).to be_success
      expect(result[:model].reload.permissions.size).to be(2)
      expect(result[:model].reload.name).to eq('other')
    end

    context 'when the payload has no permissions' do
      before do
        params[:permission_ids] = []
      end

      it 'does not remove all permissions' do
        expect(result).to be_success
        expect(role.reload.permissions.size).to be(1)
      end
    end
  end

  context 'with invalid parameters' do
    before do
      params[:name] = 'invalid'
    end

    it 'does not update the role' do
      expect { result }.not_to change { role.reload.name }
    end

    context 'when the role has no permissions' do
      before do
        params[:permission_ids] = []
      end

      it 'does not remove all permissions' do
        expect(result).to be_failure
        expect(result).to fail_a_contract
      end
    end
  end

  context 'when an exception is raised' do
    before do
      allow_any_instance_of(Role::Contract::Update).to receive(:validate).and_raise(StandardError, "Random Error")
    end

    it 'rescues the exception and maps it to a custom error' do
      expect(result).to be_failure
      expect(result["result.defaultapi.rescue"]).to be_a(Dry::Monads::Result::Failure)
    end    
  end

  context 'when the role is not found' do
    before do
      params[:id] = -1
    end

    it 'does not update any role' do
      expect(result).to be_failure
    end
  end
end
