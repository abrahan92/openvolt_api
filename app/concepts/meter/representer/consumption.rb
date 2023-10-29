require 'representable/json'

class Meter::Representer::Consumption < Representable::Decorator
  include Representable::JSON
  
  property :amount
  property :unit
end
