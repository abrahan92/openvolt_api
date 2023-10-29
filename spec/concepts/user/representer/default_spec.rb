# spec/concepts/user/representer/default_spec.rb

RSpec.describe User::Representer::Default do
  describe '#to_json' do
    let(:user) { create(:user, :other_profile) }
    let(:decorator) { described_class.new(user) }
    let(:roles) { create(:role) }
    let(:json) { JSON.parse(decorator.to_json) }

    before do
      user.roles << roles
    end

    it 'includes id' do
      expect(json['id']).to eq(user.id)
    end

    it 'includes email' do
      expect(json['email']).to eq(user.email)
    end

    it 'includes created_at' do
      expect(json['created_at']).to eq(user.created_at.as_json)
    end

    it 'includes updated_at' do
      expect(json['updated_at']).to eq(user.updated_at.as_json)
    end

    it 'includes provider' do
      expect(json['provider']).to eq(user.provider)
    end

    it 'includes name' do
      expect(json['name']).to eq(user.name)
    end

    it 'includes lastname' do
      expect(json['lastname']).to eq(user.lastname)
    end

    it 'includes properties' do
      expect(json['properties']).to eq(user.properties)
      expect(json['properties']).to include({
        'account_type' => user.properties['account_type'],
        'platform_access' => user.properties['platform_access']
      })
    end

    context 'when the account_type is other' do
      it 'includes other profile' do
        expect(json['profile']).to_not be_nil
        expect(json['profile']).to include({
          'birthdate' => user.other.birthdate.to_s,
          'phone_number' => user.other.phone_number,
          'user_id' => user.other.user_id,
        })
      end
    end

    context 'when the account_type is new_other' do
      let(:user) { create(:user, :new_other_profile) }

      it 'includes new_other profile' do
        expect(json['profile']).to_not be_nil
        expect(json['profile']).to include({
          'birthdate' => user.new_other.birthdate.to_s,
          'phone_number' => user.new_other.phone_number,
          'user_id' => user.new_other.user_id
        })
      end
    end

    context 'when the account_type is admin' do
      let(:user) { create(:user, :admin_profile) }

      it 'includes admin profile' do
        expect(json['profile']).to_not be_nil
        expect(json['profile']).to include({
          'user_id' => user.admin.user_id
        })
      end
    end

    it 'includes picture_url' do
      expect(json['picture_url']).to eq(user.picture_url)
    end

    it 'includes roles' do
      expect(json['roles']).to be_an(Array)
      
      json['roles'].each do |role_hash|
        expect(role_hash.keys).to include('id', 'name', 'resource_id', 'resource_type', 'created_at', 'updated_at')
      end
    end

    it 'includes default_role' do
      expect(json['default_role']).to include({
        'id' => roles.id,
        'name' => roles.name
      })
    end

    it 'includes permissions' do
      expect(json['permissions']).to be_an(Array)
      
      json['permissions'].each do |permission_hash|
        expect(permission_hash.keys).to include('action_perform', 'subject')
      end
    end
  end
end