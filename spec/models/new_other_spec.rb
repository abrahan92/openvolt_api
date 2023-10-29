# spec/models/new_other_spec.rb

RSpec.describe NewOther, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'callbacks' do
    let(:user) { create(:user) }

    context 'before_save' do
      it 'sets user properties' do
        new_other = build(:new_other, user: user)
        new_other.save!

        expect(user.reload.properties['platform_access']).to eq('mobile')
        expect(user.reload.properties['account_type']).to eq('new_other')
      end
    end
  end

  describe "validations" do
    let(:user) { create(:user) }

    context "when a user already has a other profile" do
      before do
        create(:other, user: user)
      end

      it "does not allow the user to have a new_other profile" do
        new_other = build(:new_other, user: user)
        expect(new_other).not_to be_valid
        expect(new_other.errors[:user]).to include("already has another profile")
      end
    end

    context "when a user already has an admin profile" do
      before do
        create(:admin, user: user)
      end

      it "does not allow the user to have a other profile" do
        new_other = build(:new_other, user: user)
        expect(new_other).not_to be_valid
        expect(new_other.errors[:user]).to include("already has another profile")
      end
    end
  end
end