RSpec.shared_context 'with roles' do |role_name|
  before do
    if defined?(user)
      user.roles << create(:role, role_name)
    else
      let!(:user) do
        user = create(:user)
        user.roles << create(:role, role_name)
        user
      end
    end
  end
end