module Errors
  class Trailblazer::Contract < StandardError
    attr_reader :data
  
    def initialize(message, data = nil)
      @data = data
      super(message)
    end
  end
end