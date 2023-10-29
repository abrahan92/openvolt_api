# spec/concepts/user/operation/delete_spec.rb

RSpec.describe User::Operation::Delete, type: :operation do
  let!(:user) { create(:user, :other) }
  let(:params) do
    {
      id: user.id
    }
  end

  subject(:result) { described_class.call(params) }

  before do
    RSpec.configuration.current_user = create(:admin).user
  end

  describe 'Delete User' do
    context 'when user exists' do
      it 'deletes the user' do
        expect { result }.to change { User.count }.by(-1)
      end
    end

    context 'when user does not exist' do
      let(:params) do
        {
          id: -1
        }
      end

      it 'does not delete any user and returns a failure' do
        expect(result).not_to be_success
        expect { result }.not_to change { User.count }
      end
    end

    context 'when deletion fails' do
      before do
        allow_any_instance_of(User).to receive(:destroy).and_raise(StandardError)
      end

      it 'returns a failure monad' do
        expect(result).not_to be_success
        expect(result['result.defaultapi.rescue']).to be_a(Dry::Monads::Failure)
      end
    end

    context 'when user is not an admin' do
      before do
        RSpec.configuration.current_user = create(:other).user
      end

      it 'fails policy action_allowed_for_admin' do
        expect(result).to fail_a_policy(:action_allowed_for_admin)
      end
    end
  end
end
