# spec/concepts/permission/operation/update_spec.rb

# spec/concepts/role/operation/update_spec.rb

RSpec.describe Permission::Operation::Update do
  let!(:permission) { create(:permission) }
  let(:params) do
    {
      id: permission.id,
      action_perform: 'delete'
    }
  end

  subject(:result) { described_class.call(params) }

  context 'with valid parameters' do
    it 'updates just the permission action perform' do
      expect(result).to be_success
      expect(result[:model].reload.action_perform).to eq('delete')
    end
  end

  context 'with invalid parameters' do
    before do
      params[:subject] = nil
    end

    it 'does not update the permission' do
      expect { result }.not_to change { permission.reload.subject }
      expect(result).to fail_a_contract
    end
  end

  context 'when an exception is raised' do
    before do
      allow_any_instance_of(Permission::Contract::Create).to receive(:validate).and_raise(StandardError)
    end

    it 'rescues the exception and maps it to a custom error' do
      expect(result).to be_failure
      expect(result['result.defaultapi.rescue'].failure.error).to be_a(StandardError)
    end    
  end

  context 'when the permission is not found' do
    before do
      params[:id] = -1
    end

    it 'does not update any permission' do
      expect(result).to be_failure
    end
  end
end
