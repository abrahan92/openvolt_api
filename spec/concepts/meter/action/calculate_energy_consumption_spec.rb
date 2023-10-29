RSpec.describe Meter::Action::CalculateEnergyConsumption do
  let(:start_date) { "2023-01-01" }
  let(:end_date) { "2023-01-02" }
  let(:granularity) { "hh" }
  let(:meter_id) { "6514167223e3d1424bf82742" }

  let(:fake_url) { "https://fake.openbolt.uri/v1/interval-data?meter_id=#{meter_id}&start_date=#{start_date}&end_date=#{end_date}&granularity=#{granularity}" }

  let(:model) do
    data = Struct.new(:meter_id, :start_date, :end_date, :energy_consumption, :carbon_emission, :fuel_mix, :interval_consumption).new(
      meter_id, start_date, end_date
    )
    Struct.new(:data).new(data)
  end

  before do
    stub_request(:get, fake_url)
      .with(headers: { "x-api-key" => "fake_openbolt_api_key" })
      .to_return(status: 200, body: {
        data: [
          { "consumption" => "50", "consumption_units" => "kWh" },
          { "consumption" => "51", "consumption_units" => "kWh" }
        ]
      }.to_json)
  end

  subject(:result) { described_class.call(params: { start_date: start_date, end_date: end_date, granularity: granularity, meter_id: meter_id }, model: model) }

  describe '.call' do
    it 'calculates the overall energy consumption' do
      expect(result).to be_a_kind_of(Struct)
      expect(result.amount).to eq(2761.0)
      expect(result.unit).to eq("kWh")
    end
  end
end
