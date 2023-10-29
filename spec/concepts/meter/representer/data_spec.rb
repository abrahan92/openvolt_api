# spec/concepts/meter/representer/data_spec.rb

RSpec.describe Meter::Representer::Data do
  describe '#to_json' do
    let(:object) do
      Struct.new(:data).new(
        Struct.new(:meter_id, :start_date, :end_date, :energy_consumption, :carbon_emission, :fuel_mix).new(
          1,
          Date.today,
          Date.today + 1,
          Struct.new(:amount, :unit).new(1, 'kWh'),
          Struct.new(:amount, :unit).new(1, 'kgCO2'),
          [
            Struct.new(:name, :amount, :unit).new('Coal', 1, '%'),
          ]
        )
      )
    end
    let(:decorator) { described_class.new(object) }
    let(:json) { JSON.parse(decorator.to_json) }

    it 'includes meter_id' do
      expect(json['data']['meter_id']).to eq(object.data.meter_id)
    end

    it 'includes start_date' do
      expect(json['data']['start_date']).to eq(object.data.start_date.as_json)
    end

    it 'includes end_date' do
      expect(json['data']['end_date']).to eq(object.data.end_date.as_json)
    end

    describe 'energy_consumption' do
      it 'is present' do
        expect(json['data']['energy_consumption']).to_not be_nil
      end

      it 'includes amount' do
        expect(json['data']['energy_consumption']['amount']).to eq(object.data.energy_consumption.amount)
      end

      it 'includes unit' do
        expect(json['data']['energy_consumption']['unit']).to eq(object.data.energy_consumption.unit)
      end
    end

    describe 'carbon_emission' do
      it 'is present' do
        expect(json['data']['carbon_emission']).to_not be_nil
      end

      it 'includes amount' do
        expect(json['data']['carbon_emission']['amount']).to eq(object.data.carbon_emission.amount)
      end

      it 'includes unit' do
        expect(json['data']['carbon_emission']['unit']).to eq(object.data.carbon_emission.unit)
      end
    end

    describe 'fuel_mix' do
      it 'is present and an array' do
        expect(json['data']['fuel_mix']).to be_an(Array)
      end

      it 'includes fuel mix details' do
        json['data']['fuel_mix'].each_with_index do |fuel_mix_hash, index|
          fuel_mix = object.data.fuel_mix[index]
          expect(fuel_mix_hash['name']).to eq(fuel_mix.name)
          expect(fuel_mix_hash['amount']).to eq(fuel_mix.amount)
          expect(fuel_mix_hash['unit']).to eq(fuel_mix.unit)
        end
      end
    end
  end
end
