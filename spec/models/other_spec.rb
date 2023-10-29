# spec/models/other_spec.rb

RSpec.describe Other, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'callbacks' do
    let(:user) { create(:user) }

    context 'before_save' do
      it 'sets user properties' do
        other = build(:other, user: user)
        other.save!

        expect(user.reload.properties['platform_access']).to eq('mobile')
        expect(user.reload.properties['account_type']).to eq('other')
      end
    end
  end

  describe "validations" do
    let(:user) { create(:user) }

    context "when a user already has a health professional profile" do
      before do
        create(:new_other, user: user)
      end

      it "does not allow the user to have a other profile" do
        other = build(:other, user: user)
        expect(other).not_to be_valid
        expect(other.errors[:user]).to include("already has another profile")
      end
    end

    context "when a user already has an admin profile" do
      before do
        create(:admin, user: user)
      end

      it "does not allow the user to have a other profile" do
        other = build(:other, user: user)
        expect(other).not_to be_valid
        expect(other.errors[:user]).to include("already has another profile")
      end
    end
  end
end