# spec/concepts/user/operation/list_others_spec.rb

RSpec.describe User::Operation::ListOthers, type: :operation do
  describe 'List Others Operation' do
    subject(:result) { described_class.call }

    context "when user is an admin" do
      before do
        RSpec.configuration.current_user = create(:admin).user
      end

      context 'when listing users' do
        let!(:other) { create(:other) }

        it 'returns all users in options[:model]' do
          expect(result).to be_success
          expect(result[:model]).to all(be_a(Other))
        end
      end

      context 'when no users are present' do
        before do
          Other.destroy_all
          Admin.destroy_all
          NewOther.destroy_all
          User.destroy_all
        end
        
        it 'returns an empty array in options[:model]' do
          expect(result).to be_success
          expect(result[:model]).to match_array([])
        end
      end
    end

    context "when user is not an admin" do
      it 'fails policy action_allowed_for_admin' do
        expect(result).to fail_a_policy(:action_allowed_for_admin)
      end
    end
  end
end
