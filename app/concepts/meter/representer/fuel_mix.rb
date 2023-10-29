require 'representable/json'

class Meter::Representer::FuelMix < Representable::Decorator
  include Representable::JSON
  
  property :name
  property :amount
  property :unit
end
