# spec/concepts/permission/representer/default_spec.rb

RSpec.describe Permission::Representer::Default, type: :representer do
  let(:permission) { create(:permission) }
  let(:representer) { described_class.new(permission) }

  describe 'JSON serialization' do
    it 'serializes to JSON' do
      json = representer.to_json

      expect(JSON.parse(json)).to eq({
        "id" => permission.id,
        "action_perform" => permission.action_perform,
        "subject" => permission.subject,
        "created_at" => permission.created_at.as_json,
        "updated_at" => permission.updated_at.as_json
      })
    end
  end
end