class Meter::Action::CalculateFuelMixUsed
  extend Memoist

  method_object %i[params model]

  def call
    overall_fuel_mix
  end

  private

  def url
    "#{Settings.meter.national_grid_uri}/generation/#{params[:start_date]}/#{params[:end_date]}"
  end

  def generation_mix
    Platform::Http.get(url)["data"]
  end
  memoize :generation_mix

  def overall_fuel_mix
    total_fuel_mix = Hash.new(0)
    collection_fuel_mix = Array.new
  
    model.data.interval_consumption.each do |interval|
      consumption = interval["consumption"].to_f
  
      matching_generation = generation_mix.find { |gm| gm["from"].to_datetime == interval["start_interval"].to_datetime }
  
      next unless matching_generation  # skip if no matching generation mix data is found
      
      matching_generation["generationmix"].each do |fuel_data|
        fuel_type = fuel_data["fuel"]
        percentage = fuel_data["perc"].to_f / 100  # Convert percentage to a fraction
  
        total_fuel_mix[fuel_type] += consumption * percentage
      end
    end
  
    total_consumption = model.data.energy_consumption.amount
  
    # Convert the total fuel mix to percentages
    total_fuel_mix.each do |fuel_type, value|
      collection_fuel_mix << Struct.new(:name, :amount, :unit).new(
        fuel_type,
        (value / total_consumption * 100).round(2),
        "%"
      )
    end
  
    model.data.fuel_mix = collection_fuel_mix
  end
end
