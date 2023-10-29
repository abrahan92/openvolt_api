# spec/concepts/role/operation/create_spec.rb

RSpec.describe Role::Operation::Create, type: :operation do
  describe 'Call' do
    let(:permission) { create(:permission) }
    let(:params) do
      {
        name: 'admin',
        permission_ids: [permission.id]
      }
    end
    
    subject(:result) { described_class.call(params) }

    context 'when valid params' do
      it 'is successful' do
        expect(result).to be_success
      end

      it 'creates a new Role' do
        expect { result }.to change { Role.count }.by(1)
      end

      it 'assigns permissions to Role' do
        permissions = Permission.where(id: params[:permission_ids])
        expect(result[:model].reload.permissions).to match_array(permissions)
      end
    end

    context 'when invalid params' do
      let(:params) { { name: 'invalid_name' } }

      it 'is a failure' do
        expect(result).to be_failure
      end

      it 'does not create a new Role' do
        expect { result }.not_to change { Role.count }
      end

      context 'when the payload has no permissions' do
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
        allow(Permission).to receive(:where).and_raise(StandardError)
      end

      it 'is a failure' do
        expect(result).to be_failure
      end

      it 'handles the error' do
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(StandardError)
      end
    end
  end
end
