# spec/concepts/user/policy/user_can_create_user_spec.rb

RSpec.describe User::Policy::UserCanCreateUser do
  describe '.call' do
    let(:params) { {} }
    let(:options) { {} }
    let(:current_user) { create(:admin).user }
    let(:other) { create(:other) }
    let(:new_other) { create(:new_other) }

    subject(:policy_result) do
      described_class.call(options, params: params, current_user: current_user)
    end

    context 'when current_user is admin' do
      it 'returns true' do
        expect(policy_result).to be true
      end
    end

    context 'when current_user is new_other' do
      let(:current_user) { new_other.user }

      it 'returns false' do
        expect(policy_result).to be false
      end
    end

    context 'when current_user is other' do
      let(:current_user) { other.user }
      
      it 'returns false' do
        expect(policy_result).to be false
      end
    end

    context 'when an exception is raised' do
      before do
        allow_any_instance_of(User).to receive(:admin?).and_raise(StandardError)
      end

      it 'returns false' do
        expect(policy_result).to be false
      end
    end
  end
end
