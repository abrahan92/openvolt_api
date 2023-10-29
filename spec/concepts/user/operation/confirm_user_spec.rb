# spec/concepts/user/operation/confirm_user_spec.rb

RSpec.describe User::Operation::ConfirmUser, type: :operation do
  describe 'ConfirmUser Operation' do
    let!(:current_user) { create(:user, :super_admin_profile) }
    let!(:user) { create(:user, :new_other_profile, :unconfirmed) }
    let(:role) { create(:role, :super_admin) }
    let(:params) { { id: user.id } }

    subject(:result) { described_class.call({ id: user.id }, current_user: current_user) }

    before do
      current_user.roles << role
    end

    context 'when a super admin confirms a user' do
      it 'confirms the user successfully' do
        expect(result).to be_success
        expect(user.reload).to be_confirmed
      end
    end

    context 'when a non-super admin tries to confirm a user' do
      let!(:current_user) { create(:user, :other_profile) }
      
      before do
        current_user.roles.destroy_all
      end

      it 'fails to confirm the user' do
        expect(result).to be_failure
        expect(user.reload).not_to be_confirmed
      end

      it 'fails policy action_allowed_for_admin' do
        expect(result).to fail_a_policy(:action_allowed_for_admin)
      end
    end

    context 'when confirming the user fails for some reason' do
      before do
        allow_any_instance_of(User).to receive(:confirm).and_return(false)
      end

      it 'handles the error and fails' do
        expect(result).to be_failure
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(User::ConfirmUserError)
      end
    end
  end
end
