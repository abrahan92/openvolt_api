# spec/concepts/meter/representer/carbon_emission_spec.rb

RSpec.describe Meter::Representer::CarbonEmission do
  describe '#to_json' do
    let(:carbon_emission) do
      Struct.new(:amount, :unit).new(50, 'kgCO2')
    end
    let(:decorator) { described_class.new(carbon_emission) }
    let(:json) { JSON.parse(decorator.to_json) }

    it 'includes amount' do
      expect(json['amount']).to eq(carbon_emission.amount)
    end

    it 'includes unit' do
      expect(json['unit']).to eq(carbon_emission.unit)
    end
  end
end
