# spec/concepts/permission/operation/delete_spec.rb

RSpec.describe Permission::Operation::Delete, type: :operation do
  describe 'Deleting a Permission' do
    let!(:permission) { create(:permission, action_perform: 'read', subject: 'home') }
    let(:params) { { id: permission.id } }

    subject(:result) { described_class.call(params) }

    context 'with valid id' do
      it 'successfully deletes a permission' do
        expect(result).to be_success
        expect(Permission.find_by(id: permission.id)).to be_nil
      end
    end

    context 'with invalid id' do
      before do
        params[:id] = -1
      end

      it 'fails to delete a permission' do
        expect(result).to be_failure
      end
    end

    context 'with an exception' do
      before do
        allow_any_instance_of(Permission).to receive(:destroy).and_raise(StandardError)
      end

      it 'handles the exception and fails' do
        expect(result).to be_failure
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(StandardError)
      end
    end
  end
end