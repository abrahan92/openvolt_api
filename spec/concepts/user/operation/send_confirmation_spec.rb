# spec/concepts/user/operation/send_confirmation_spec.rb

RSpec.describe User::Operation::SendConfirmation, type: :operation do
  describe 'Send Confirmation Email' do
    let!(:user) { create(:user, :new_other_profile) } 
    let(:params) { { id: user.id } }

    subject(:result) { described_class.call(params) }

    context "when user is an admin" do
      before do
        RSpec.configuration.current_user = create(:admin).user
      end
  
      context 'when the user is found and email is sent' do
        it 'returns success' do
          expect(result).to be_success
        end
      end
  
      context 'when the user is not found' do
        let(:params) { { id: 0 } }
        
        it 'returns failure' do
          expect(result).to be_failure
        end
      end
  
      context 'when an exception is thrown' do
        before do
          allow_any_instance_of(User).to receive(:send_confirmation_instructions).and_raise(StandardError)
        end
  
        it 'handles the exception and returns a failure' do
          expect(result).to be_failure
          expect(result['result.defaultapi.rescue'].failure.error).to be_a(StandardError)
        end
      end
    end

    context 'when the current_user id mismatch with the user id' do
      it 'fails policy action_allowed_for_user' do
        expect(result).to fail_a_policy(:action_allowed_for_user)
      end
    end
  end
end
