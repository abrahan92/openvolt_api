require 'representable/json'

class Meter::Representer::CarbonEmission < Representable::Decorator
  include Representable::JSON
  
  property :amount
  property :unit
end
