# spec/concepts/user/representer/list_spec.rb

RSpec.describe User::Representer::List do
  let(:user) { create(:user) } # Assumes you have a factory for users
  let(:representer) { described_class.new(user) }
  
  subject(:json) { JSON.parse(representer.to_json) }

  describe '#to_json' do
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
  end
end