# spec/models/admin_spec.rb

RSpec.describe Admin, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'callbacks' do
    let(:user) { create(:user) }

    context 'before_save' do
      it 'sets user properties' do
        admin = build(:admin, user: user)
        admin.save!

        expect(user.reload.properties['platform_access']).to eq('all')
        expect(user.reload.properties['account_type']).to eq('admin')
      end
    end
  end

  describe "validations" do
    let(:user) { create(:user) }

    context "when a user already has a other profile" do
      before do
        create(:other, user: user)
      end

      it "does not allow the user to have a admin profile" do
        admin = build(:admin, user: user)
        expect(admin).not_to be_valid
        expect(admin.errors[:user]).to include("already has another profile")
      end
    end

    context "when a user already has an new_other profile" do
      before do
        create(:new_other, user: user)
      end

      it "does not allow the user to have a new_other profile" do
        admin = build(:admin, user: user)
        expect(admin).not_to be_valid
        expect(admin.errors[:user]).to include("already has another profile")
      end
    end
  end
end