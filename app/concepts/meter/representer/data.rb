require 'representable/json'

class Meter::Representer::Data < Representable::Decorator
  include Representable::JSON
  
  property :data do
    property :meter_id
    property :start_date
    property :end_date
    property :energy_consumption, decorator: Meter::Representer::Consumption
    property :carbon_emission, decorator: Meter::Representer::CarbonEmission
    collection :fuel_mix, decorator: Meter::Representer::FuelMix
  end
end
