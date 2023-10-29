RSpec.shared_context "doorkeeper_authentication" do |user_type|
  let(:user) { create(:user, user_type) }
  let(:application) { create(:oauth_application) }
  let(:token) do
    Doorkeeper::AccessToken.create!(
      resource_owner_id: user.id,
      application: application,
      scopes: "read",
      refresh_token: "1234567890"
    )
  end

  before do
    request.headers['Authorization'] = "Bearer #{token.token}"
  end
end