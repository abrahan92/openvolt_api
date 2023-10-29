# spec/concepts/user/operation/create_profile_spec.rb

RSpec.describe User::Operation::CreateProfile, type: :operation do
  describe 'Create Profile' do
    let!(:user) { create(:user, :other_profile) }
    let(:params) do
      {
        model: user,
      }
    end

    subject(:result) { described_class.call(params) }

    context 'when policy fails' do
      it { is_expected.to fail_a_policy :profile_params_required }
    end

    context 'when policy succeeds' do
      let!(:params) do
        {
          model: user,
          profile: { 
            "birthdate": "1991-10-25",
            "phone_number": "12345678"
           },
        }
      end

      it { is_expected.to be_success }
    end
  end
end
