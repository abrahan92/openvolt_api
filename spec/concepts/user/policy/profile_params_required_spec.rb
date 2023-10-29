# spec/concepts/user/policy/profile_params_required_spec.rb

RSpec.describe User::Policy::ProfileParamsRequired do
  describe '.call' do
    context 'when user is not found' do
      it 'returns false' do
        result = described_class.call({}, params: { model: OpenStruct.new(id: -1) })
        expect(result).to be(false)
      end
    end

    context 'when user is found' do
      let(:user) { create(:user, properties: { account_type: 'admin' }) }

      context 'when profile params are present' do
        it 'returns true' do
          result = described_class.call({}, params: { model: OpenStruct.new(id: user.id), profile: { some_key: 'some_value' } })
          expect(result).to be(true)
        end
      end

      context 'when profile params are not present but user is an admin' do
        it 'returns true' do
          result = described_class.call({}, params: { model: OpenStruct.new(id: user.id) })
          expect(result).to be(true)
        end
      end

      context 'when profile params are not present and user is not an admin' do
        let(:user) { create(:user, properties: { account_type: 'user' }) }

        it 'returns false' do
          result = described_class.call({}, params: { model: OpenStruct.new(id: user.id) })
          expect(result).to be(false)
        end
      end
    end
  end
end