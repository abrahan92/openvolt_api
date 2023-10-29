# spec/concepts/role/operation/delete_spec.rb

RSpec.describe Role::Operation::Delete do
  let!(:role) { create(:role) }
  let(:params) { { id: role.id } }

  subject(:result) { described_class.call(params) }
  
  describe 'successful delete' do
    it 'deletes the role' do
      expect { result }.to change(Role, :count).by(-1)
      expect(result.success?).to be true
    end
  end

  describe 'unsuccessful delete' do
    let(:params) { { id: -1 } }

    it 'does not delete any role' do
      expect { result }.not_to change(Role, :count)
      expect(result.failure?).to be true
    end
  end
  
  describe 'rescue from failure' do
    before do
      allow(Role).to receive(:find_by).and_raise(StandardError.new("Random error"))
    end

    it 'does not delete the role and maps to custom error' do
      expect { result }.not_to change(Role, :count)
      expect(result.failure?).to be true

      rescue_result = result["result.defaultapi.rescue"]
      expect(rescue_result).to be_a(Dry::Monads::Result::Failure)
      expect(rescue_result.failure).to be_a(ApiError::DefaultApiError::Base)
    end
  end
end
