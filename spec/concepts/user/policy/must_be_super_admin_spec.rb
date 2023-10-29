# spec/concepts/user/policy/must_be_super_admin_spec.rb

RSpec.describe User::Policy::MustBeSuperAdmin do
  describe '.call' do
    context 'when the user is a super admin' do
      let(:super_admin) { create(:user, :super_admin_profile) }
      let(:role) { create(:role, :super_admin) }

      before do
        super_admin.roles << role
      end

      it 'returns true' do
        result = described_class.call({}, current_user: super_admin)
        expect(result).to be(true)
      end
    end

    context 'when the user is not a super admin' do
      let(:regular_user) { create(:user, :other_profile) }

      it 'returns false' do
        result = described_class.call({}, current_user: regular_user)
        expect(result).to be(false)
      end
    end
  end
end