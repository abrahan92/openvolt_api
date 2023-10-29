# spec/concepts/permission/operation/show_spec.rb

RSpec.describe Permission::Operation::Show do
  let!(:permission) { create(:permission) }
  let(:params) { { id: permission.id } }

  subject(:result) { described_class.call(params) }

  context 'when given a valid id' do
    it 'retrieves the permission' do
      expect(result).to be_success
      expect(result['model']).to eq(permission)
    end
  end

  context 'when given an invalid id' do
    before do
      params[:id] = -1
    end
    
    it 'does not retrieve any permission' do
      expect(result).to be_failure
      expect(result['model']).to be_nil
    end
  end
end
