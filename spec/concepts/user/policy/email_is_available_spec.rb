# spec/concepts/user/policy/email_is_available_spec.rb

RSpec.describe User::Policy::EmailIsAvailable do
  describe '.call' do
    context 'when the email is already taken' do
      let!(:existing_user) { create(:user, email: 'taken@email.com') }

      it 'returns false' do
        params = { email: 'taken@email.com' }
        result = described_class.call({}, params: params)

        expect(result).to be(false)
      end
    end

    context 'when the email is available' do
      it 'returns true' do
        params = { email: 'available@email.com' }
        result = described_class.call({}, params: params)

        expect(result).to be(true)
      end
    end
  end
end