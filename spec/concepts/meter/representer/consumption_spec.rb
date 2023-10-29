# spec/concepts/meter/representer/consumption_spec.rb

RSpec.describe Meter::Representer::Consumption do
  describe '#to_json' do
    let(:consumption) do
      Struct.new(:amount, :unit).new(100, 'kWh')
    end
    let(:decorator) { described_class.new(consumption) }
    let(:json) { JSON.parse(decorator.to_json) }

    it 'includes amount' do
      expect(json['amount']).to eq(consumption.amount)
    end

    it 'includes unit' do
      expect(json['unit']).to eq(consumption.unit)
    end
  end
end