RSpec.describe Meter::Action::CalculateFuelMixUsed do
  let(:start_date) { "2023-01-01" }
  let(:end_date) { "2023-01-02" }
  let(:fake_url) { "https://fake.national.grid.uri/generation/#{start_date}/#{end_date}" }

  IntervalConsumption = Struct.new(:start_interval, :meter_id, :meter_number, :customer_id, :consumption, :consumption_units)
  EnergyConsumption = Struct.new(:amount, :unit)
  CarbonEmission = Struct.new(:amount, :unit)

  let(:interval_consumptions) do
    [
      IntervalConsumption.new("2023-01-01T00:00:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh"),
      IntervalConsumption.new("2023-01-01T00:30:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh"),
      IntervalConsumption.new("2023-01-01T01:00:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh"),
      IntervalConsumption.new("2023-01-01T01:30:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh")
    ]
  end

  let(:energy_consumption) { EnergyConsumption.new(108.0, "kWh") }
  let(:carbon_emission) { CarbonEmission.new(10.0, "kgCO2") }

  let(:data) do
    Struct.new(:meter_id, :start_date, :end_date, :energy_consumption, :carbon_emission, :fuel_mix, :interval_consumption).new(
      "6514167223e3d1424bf82742", start_date, end_date, energy_consumption, carbon_emission, nil, interval_consumptions
    )
  end

  let(:model) { Struct.new(:data).new(data) }

  before do
    stub_request(:get, fake_url)
      .to_return(status: 200, body: {
        data: [
          {
            "from" => "2023-01-01T00:00Z",
            "to" => "2023-01-01T00:30Z",
            "generationmix" => [
              { "fuel" => "coal", "perc" => 40.0 },
              { "fuel" => "wind", "perc" => 60.0 }
            ]
          },
          {
            "from" => "2023-01-01T00:30Z",
            "to" => "2023-01-01T01:00Z",
            "generationmix" => [
              { "fuel" => "coal", "perc" => 30.0 },
              { "fuel" => "wind", "perc" => 70.0 }
            ]
          }
        ]
      }.to_json)
  end

  subject(:result) { described_class.call(params: { start_date: start_date, end_date: end_date }, model: model) }

  describe '.call' do
    it 'calculates the overall fuel mix' do
      expect(result).to be_a_kind_of(Array)
      expect(result.first.name).to eq("biomass")
      expect(result.first.amount).to be > 0
      expect(result.first.unit).to eq("%")
    end
  end
end