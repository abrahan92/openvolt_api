# spec/concepts/meter/representer/fuel_mix_spec.rb

RSpec.describe Meter::Representer::FuelMix do
  describe '#to_json' do
    let(:fuel_mix) do
      Struct.new(:name, :amount, :unit).new('Coal', 1, '%')
    end
    let(:decorator) { described_class.new(fuel_mix) }
    let(:json) { JSON.parse(decorator.to_json) }

    it 'includes name' do
      expect(json['name']).to eq(fuel_mix.name)
    end

    it 'includes amount' do
      expect(json['amount']).to eq(fuel_mix.amount)
    end

    it 'includes unit' do
      expect(json['unit']).to eq(fuel_mix.unit)
    end
  end
end
