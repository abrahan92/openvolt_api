# spec/concepts/user/policy/passwords_match_spec.rb

RSpec.describe User::Policy::PasswordsMatch do
  describe '.call' do
    context 'when the passwords match' do
      let(:params) { { password: 'password123', password_confirmation: 'password123' } }

      it 'returns true' do
        result = described_class.call({}, params: params)
        expect(result).to be(true)
      end
    end

    context 'when the passwords do not match' do
      let(:params) { { password: 'password123', password_confirmation: 'password321' } }

      it 'returns false' do
        result = described_class.call({}, params: params)
        expect(result).to be(false)
      end
    end

    context 'when the passwords are nil' do
      let(:params) { { password: nil, password_confirmation: nil } }

      it 'returns true' do
        result = described_class.call({}, params: params)
        expect(result).to be(true)
      end
    end
  end
end