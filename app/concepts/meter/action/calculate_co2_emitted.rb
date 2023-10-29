class Meter::Action::CalculateCo2Emitted
  extend Memoist

  method_object %i[params model interval_consumption]

  def call
    overall_carbon_emission
  end

  private

  def url
    "#{Settings.meter.national_grid_uri}/intensity/#{params[:start_date]}/#{params[:end_date]}"
  end

  def carbon_emission
    Platform::Http.get(url)["data"]
  end
  memoize :carbon_emission

  def overall_carbon_emission
    total_emission = 0
  
    model.data.interval_consumption.each do |interval|
      consumption = interval["consumption"].to_f

      matching_intensity = carbon_emission.find { |ci| ci["from"].to_datetime == interval["start_interval"].to_datetime }
  
      next unless matching_intensity  # skip if no matching carbon intensity data is found
  
      carbon_intensity = matching_intensity["intensity"]["actual"].to_f
  
      # Assuming carbon intensity is given in gCO2/kWh, so we convert it to kgCO2/kWh
      emission_for_interval = consumption * (carbon_intensity / 1000)
      total_emission += emission_for_interval
    end
  
    model.data.carbon_emission = Struct.new(:amount, :unit).new(total_emission.round(2), "kgCO2")
  end
end
