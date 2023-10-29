module Trailblazer::Extensions
  module Operation
    module Result
      extend Forwardable
      def_delegators :@data, :[]=

      def results
        @data.to_hash.select { |k, _v| k.to_s.starts_with?("result.") }
      end

      def failures
        results.select { |_k, v| v.respond_to?(:failure?) && v.failure? }
      end

      def raisable?
        failures.any? do |k, _v|
          !k.to_s.starts_with?("result.contract.") && !k.to_s.starts_with?("result.policy.")
        end
      end

      def to_hash
        @data.to_hash
      end

      def policy_failed?(policy)
        failures.any? do |k, _v|
          k.to_s == "result.policy.#{policy}"
        end
      end

      def contract_failed?(contract, validation)
        failures.any? do |k, v|
          k.to_s == "result.contract.#{contract}" && v.errors[validation].any?
        end
      end
    end
  end
end
