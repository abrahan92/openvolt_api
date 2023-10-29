# spec/concepts/permission/operation/create_spec.rb

RSpec.describe Permission::Operation::Create, type: :operation do
  describe 'Creating a Permission' do
    let(:params) { { action_perform: 'read', subject: 'home' } }

    subject(:result) { described_class.call(params) }
    
    context 'with valid params' do
      it 'successfully creates a permission' do
        expect(result).to be_success
        expect(result[:model].id).to_not be_nil
      end
    end

    context 'with invalid params' do
      before do
        params[:action_perform] = nil
      end

      it 'fails to create a permission' do
        expect(result).to be_failure
        expect(result).to fail_a_contract
      end
    end

    context 'with an exception' do
      before do
        allow_any_instance_of(Permission::Contract::Create).to receive(:validate).and_raise(StandardError)
      end

      it 'handles the exception and fails' do
        expect(result).to be_failure
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(StandardError)
      end
    end
  end
end