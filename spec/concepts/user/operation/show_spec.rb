# spec/concepts/user/operation/show_spec.rb

RSpec.describe User::Operation::Show do
  describe 'call' do
    context "when user is an admin" do
      before do
        RSpec.configuration.current_user = create(:admin).user
      end
      
      subject(:result) { described_class.call(params) }
  
      context 'when the user exists' do
        let(:user) { create(:other).user }
        let(:params) { { id: user.id } }
  
        it 'returns the user' do
          expect(result).to be_success
          expect(result[:model]).to eq(user)
        end
      end
  
      context 'when the user does not exist' do
        let(:params) { { id: -1 } }
  
        it 'returns failure' do
          expect(result).not_to be_success
          expect(result[:model]).to be_nil
        end
      end
    end

    context "when user is not an admin" do
      let(:user) { RSpec.configuration.current_user }
      
      subject(:result) { described_class.call(params) }
  
      context 'when the user exists' do
        let(:params) { { id: user.id } }
  
        it 'returns the user' do
          expect(result).to be_success
          expect(result[:model]).to eq(user)
        end
      end
  
      context 'when id mismatch' do
        let(:params) { { id: -1 } }
  
        it 'returns failure' do
          expect(result).not_to be_success
          expect(result[:model]).to be_nil
        end

        it "fail the policy" do
          expect(result).to fail_a_policy(:action_allowed_for_user)
        end
      end
    end
  end
end
