module Trailblazer::Extensions
  module Reform
    module Errors
      def keys
        @errors.keys
      end
    end
  end
end
