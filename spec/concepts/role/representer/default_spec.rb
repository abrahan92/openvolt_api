# spec/concepts/role/representer/default_spec.rb

RSpec.describe Role::Representer::Default, type: :representer do
  let(:user) { create(:user, :other_profile) }
  let(:role) { create(:role, name: 'other') }
  let(:another_permission) { create(:permission, subject: 'home', action_perform: 'update') }

  before do
    role.permissions << another_permission
    user.roles << role
  end

  describe '#to_json' do
    subject(:json_representation) do
      Role::Representer::Default.new(role).to_json
    end

    it 'renders the role in the expected format' do
      parsed_json = JSON.parse(json_representation)

      expect(parsed_json).to match({
        'id' => role.id,
        'name' => role.name,
        'total_users' => 1,
        'permissions' => role.reload.permissions.map do |permission|
          {
            'id' => permission.id,
            'action_perform' => permission.action_perform,
            'subject' => permission.subject,
            'created_at' => permission.created_at.as_json,
            'updated_at' => permission.updated_at.as_json
          }
        end
      })

      expect(parsed_json['permissions'].size).to eq(2)
    end
  end
end