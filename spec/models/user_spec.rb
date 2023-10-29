# spec/models/user_spec.rb

RSpec.describe User, type: :model do
  subject { create(:user, email: 'test@example.com', password: 'password1234') }

  # Validations
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  # Associations
  it { should have_many(:access_grants).dependent(:delete_all) }
  it { should have_many(:access_tokens).dependent(:delete_all) }
  it { should have_many(:permissions).through(:roles) }
  it { should have_one(:admin).dependent(:destroy) }

  describe "validations" do
    let(:user) { create(:user) }  
    context "when a user already has a other profile" do
      before do
        create(:other, user: user)
      end
  
      it "does not allow the user to have a new_other profile" do
        new_other = build(:new_other, user: user)
        expect(new_other).not_to be_valid
        expect(new_other.errors[:user]).to include('already has another profile')
      end
    end
  end  

  it "allows attachment of a picture" do
    expect(subject).to respond_to(:picture)
    expect(subject).to respond_to(:picture=)
  end

  it "allows roles to be assigned" do
    subject.add_role(:admin)
    expect(subject.has_role?(:admin)).to be_truthy
  end

  it "responds to ability checks" do
    expect(subject).to respond_to(:can?)
    expect(subject).to respond_to(:cannot?)
  end

  context 'when user is destroyed' do

    before do
      Doorkeeper::Application.create!(name: 'test', redirect_uri: 'https://example.com')
      Doorkeeper::AccessToken.create!(resource_owner_id: subject.id, application_id: Doorkeeper::Application.first.id)
    end

    it 'also destroys associated access tokens' do
      expect {
        subject.destroy
      }.to change { Doorkeeper::AccessToken.count }.by(-1)
    end
  end

  context "serializes properties" do
    let(:platform_access) { "all" }

    it "has the properties" do
      subject.properties = { 
        "platform_access" => platform_access 
      }
      subject.save!
      subject.reload
      expect(subject.properties["platform_access"]).to eq(platform_access)
    end

    it "uses store_accessor for properties" do
      subject.platform_access = "web"
      subject.account_type = "premium"
      subject.customer_stripe_identifier = "cus_123"
      subject.save!
      subject.reload
      expect(subject.platform_access).to eq("web")
      expect(subject.account_type).to eq("premium")
      expect(subject.customer_stripe_identifier).to eq("cus_123")
    end    
  end

  describe '.authenticate!' do
    context 'with valid credentials' do
      it 'returns the user' do
        authenticated_user = User.authenticate!(subject.email, subject.password)
        expect(authenticated_user).to eq(subject)
      end
    end

    context 'with invalid credentials' do
      it 'returns nil' do
        expect(User.authenticate!(subject.email, 'wrongpassword')).to be_nil
      end
    end
  end

  describe '#ability' do
    # CanCanCan abilities will likely have their own specs. Here's a simple test
    it 'returns an instance of Ability' do
      expect(subject.ability).to be_an_instance_of(Ability)
    end
  end

  describe '#authenticate_platform_access?' do
    context 'when platform_access is all' do
      before { subject.platform_access = 'all' }

      it 'returns true for any request' do
        expect(subject.authenticate_platform_access?('web')).to be_truthy
        expect(subject.authenticate_platform_access?('mobile')).to be_truthy
      end
    end

    context 'when platform_access is not all' do
      before { subject.platform_access = 'mobile' }

      it 'returns false for a request from a different platform' do
        expect(subject.authenticate_platform_access?('web')).to be_falsey
      end
    end
  end
end