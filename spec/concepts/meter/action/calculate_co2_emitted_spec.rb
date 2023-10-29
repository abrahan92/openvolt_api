RSpec.describe Meter::Action::CalculateCo2Emitted do
  let(:start_date) { "2023-01-01" }
  let(:end_date) { "2023-01-02" }
  let(:fake_url) { "https://fake.national.grid.uri/intensity/#{start_date}/#{end_date}" }

  IntervalConsumption = Struct.new(:start_interval, :meter_id, :meter_number, :customer_id, :consumption, :consumption_units)
  EnergyConsumption = Struct.new(:amount, :unit)
  Data = Struct.new(:meter_id, :start_date, :end_date, :energy_consumption, :carbon_emission, :fuel_mix, :interval_consumption)

  let(:energy_consumption) { EnergyConsumption.new(2761.0, "kWh") }

  let(:interval_consumptions) do
    [
      IntervalConsumption.new("2023-01-01T00:00:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh"),
      IntervalConsumption.new("2023-01-01T00:30:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh"),
      IntervalConsumption.new("2023-01-01T01:00:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh"),
      IntervalConsumption.new("2023-01-01T01:30:00.000Z", "6514167223e3d1424bf82742", "9999999999999", "6514153c23e3d1424bf82738", "54", "kWh")
    ]
  end
  let(:data) do
    Data.new("6514167223e3d1424bf82742", start_date, end_date, energy_consumption, nil, nil, interval_consumptions)
  end

  let(:model) do
    Struct.new(:data).new(data)
  end

  before do
    stub_request(:get, fake_url)
      .to_return(status: 200, body: {
        data: [
          {
            "from" => "2022-12-31T23:30Z",
            "to" => "2023-01-01T00:00Z",
            "intensity" => {
              "forecast" => 75,
              "actual" => 65,
              "index" => "low"
            }
          },
          {
            "from" => "2023-01-01T00:00Z",
            "to" => "2023-01-01T00:30Z",
            "intensity" => {
              "forecast" => 73,
              "actual" => 72,
              "index" => "low"
            }
          }
        ]
      }.to_json)
  end

  subject(:result) { described_class.call(params: { start_date: start_date, end_date: end_date }, model: model) }

  describe '.call' do
    it 'calculates the overall carbon emission' do
      expect(result).to be_a_kind_of(Struct)
      expect(result.amount).to be > 0
      expect(result.unit).to eq("kgCO2")
    end
  end
end
