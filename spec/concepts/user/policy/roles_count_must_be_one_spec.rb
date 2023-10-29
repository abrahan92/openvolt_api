# spec/concepts/user/policy/roles_count_must_be_one_spec.rb

RSpec.describe User::Policy::RolesCountMustBeOne do
  describe '.call' do
    subject { described_class.call({}, params: params, model: user) }

    let(:user) { create(:user, :other) }

    context 'when roles are nil' do
      let(:params) { { roles: nil } }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'when roles are present but more than one' do
      let(:params) { { roles: [1, 2] } }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when roles are present and only one' do
      let(:params) { { roles: [1] } }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'when roles are empty' do
      let(:params) { { roles: [] } }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end
end