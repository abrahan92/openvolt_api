# spec/concepts/user/operation/update_password_spec.rb

RSpec.describe User::Operation::UpdatePassword, type: :operation do
  describe 'Update Password' do
    let!(:user) { create(:user, :new_other, password: 'old_password') }
    let(:params) do
      {
        id: user.id,
        current_password: 'old_password',
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    end

    subject(:result) { described_class.call(params) }

    context 'when policy and validation pass' do
      it 'successfully updates the password' do
        expect(result).to be_success
        expect(user.reload.valid_password?('new_password')).to be_truthy
      end
    end

    context 'when policy check fails' do
      before do
        params[:password_confirmation] = 'different_password'
      end

      it { is_expected.to fail_a_policy :passwords_match }
    end

    context 'when validation fails' do
      before do
        params.delete(:current_password)
      end

      it { is_expected.to fail_a_contract }
    end

    context 'when an unexpected exception occurs' do
      before do
        allow_any_instance_of(User).to receive(:update_with_password).and_return(false)
      end

      it "raise an error" do
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(User::WrongCurrentPassword)
      end
    end
  end
end
