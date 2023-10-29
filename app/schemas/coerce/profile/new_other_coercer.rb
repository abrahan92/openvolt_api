module Coerce
  module Profile
    class NewOtherCoercer < Coercer
      COERCION_MAP = {
        'birthdate' => ->(v) { v.is_a?(String) ? v.to_date : v },
        'phone_number' => ->(v) { v }
      }.freeze
  
      # Override the parent class's coercion_map method to use our map
      def self.coercion_map
        COERCION_MAP
      end
    end
  end
end