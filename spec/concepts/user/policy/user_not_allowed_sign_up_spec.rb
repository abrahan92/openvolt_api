# spec/concepts/user/policy/user_not_allowed_sign_up_spec.rb

RSpec.describe User::Policy::UserNotAllowedSignUp do
  describe '.call' do
    subject { described_class.call({}, params: params) }

    context 'when account type is admin' do
      let(:params) { { properties: { account_type: 'admin', platform_access: 'some_access' } } }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when account type is super_admin' do
      let(:params) { { properties: { account_type: 'super_admin', platform_access: 'some_access' } } }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when platform access is all' do
      let(:params) { { properties: { account_type: 'other', platform_access: 'all' } } }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when other conditions' do
      let(:params) { { properties: { account_type: 'other', platform_access: 'mobile' } } }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end
end
