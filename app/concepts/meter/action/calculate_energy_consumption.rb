class Meter::Action::CalculateEnergyConsumption
  extend Memoist
  
  method_object %i[params model]

  def call
    overall_consumption
  end

  private

  def url
    "#{Settings.meter.openbolt_uri}/v1/interval-data?meter_id=#{params[:meter_id]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}&granularity=#{params[:granularity]}"
  end

  def headers
    { "x-api-key" => Settings.meter.openbolt_api_key }
  end

  def interval_consumption
    Platform::Http.get(url, headers)["data"]
  end
  memoize :interval_consumption

  def overall_consumption
    model.data.interval_consumption = interval_consumption
    model.data.energy_consumption = Struct.new(:amount, :unit).new(
      interval_consumption.sum { |interval| interval["consumption"].to_f }.round(2),
      "kWh"
    )
  end
end
