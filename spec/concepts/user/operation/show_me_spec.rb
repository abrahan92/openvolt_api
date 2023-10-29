# spec/concepts/user/operation/show_me_spec.rb

RSpec.describe User::Operation::ShowMe, type: :operation do
  describe 'Show Me Operation' do
    subject(:result) { described_class.call }

    let(:current_user) { RSpec.configuration.current_user }

    context 'when current_user is provided' do
      it 'returns the same user' do
        expect(result).to be_success
        expect(result[:model]).to eq(current_user)
      end
    end
  end
end

