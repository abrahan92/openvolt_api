# spec/concepts/meter/policy/dates_must_be_valid_spec.rb

RSpec.describe Meter::Policy::DatesMustBeValid do
  describe '.call' do
    let(:params) { {} }
    let(:options) { {} }

    subject(:policy_result) do
      described_class.call(options, params: params)
    end

    context 'when start_date is earlier than end_date' do
      let(:params) { { start_date: '2023-01-01', end_date: '2023-01-02' } }

      it 'returns true' do
        expect(policy_result).to be true
      end
    end

    context 'when start_date is the same as end_date' do
      let(:params) { { start_date: '2023-01-01', end_date: '2023-01-01' } }

      it 'returns false' do
        expect(policy_result).to be false
      end
    end

    context 'when start_date is later than end_date' do
      let(:params) { { start_date: '2023-01-02', end_date: '2023-01-01' } }

      it 'returns false' do
        expect(policy_result).to be false
      end
    end

    context 'when start_date or end_date is invalid' do
      let(:params) { { start_date: 'invalid-date', end_date: '2023-01-01' } }

      it 'returns false' do
        expect(policy_result).to be false
      end
    end

    context 'when start_date or end_date is missing' do
      let(:params) { { start_date: '2023-01-01' } }

      it 'returns false' do
        expect(policy_result).to be false
      end
    end
  end
end
