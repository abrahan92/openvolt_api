# spec/meter/contract/request_spec.rb

RSpec.describe Meter::Contract::Request do
  subject { described_class.new(OpenStruct.new) }

  describe 'validations' do
    context 'when valid params are passed' do
      let(:params) do
        {
          start_date: '2023-01-01',
          end_date: '2023-01-02',
          granularity: 'hh'
        }
      end

      it 'is valid' do
        subject.validate(params)
        expect(subject.errors.messages).to be_empty
      end
    end

    context 'when missing required fields' do
      it 'is invalid' do
        subject.validate({})
        expect(subject.errors.messages.keys).to include(:start_date, :end_date, :granularity)
      end
    end

    context 'when date format is invalid' do
      let(:params) do
        {
          start_date: '01-01-2023',
          end_date: '02-01-2023',
          granularity: 'hh'
        }
      end

      it 'is invalid' do
        subject.validate(params)
        expect(subject.errors.messages[:start_date]).to include('is in invalid format')
        expect(subject.errors.messages[:end_date]).to include('is in invalid format')
      end
    end

    context 'when granularity is not included in allowed values' do
      let(:params) do
        {
          start_date: '2023-01-01',
          end_date: '2023-01-02',
          granularity: 'mm'
        }
      end

      it 'is invalid' do
        subject.validate(params)
        expect(subject.errors.messages[:granularity]).to include('must be one of: hh')
      end
    end
  end
end
