# Trailblazer operation matchers
module DefaultApi
  module Matchers
    module Operation
      class FailStep
        attr_reader :name, :operation

        def initialize(name)
          @name = name
        end

        def matches?(operation)
          @operation = operation
          step_exists? && step_failed? && operation_failed?
        end

        def step_exists?
          operation[step].present?
        end

        def step_failed?
          operation[step].failure?
        end

        def operation_failed?
          operation.failure?
        end

        def failure_message
          return "expected step #{step} does not exist" unless step_exists?
          return "expected step #{step} to fail" unless step_failed?
          "expected the operation to fail but it succeeded"
        end
      end

      class FailContract < FailStep
        def step
          "result.contract.#{@name}"
        end

        def matches?(operation)
          super && has_error?
        end

        def has_error?
          operation[step].errors.present?
        end

        def failure_message
          return "expected contract #{step} to have errors" unless has_error?
          super
        end

        def description
          "fail a contract"
        end
      end

      class FailPolicy < FailStep
        def step
          "result.policy.#{@name}"
        end

        def description
          "fail a policy"
        end
      end

      class FailToFindModel < FailStep
        def initialize; end

        def step
          "result.model"
        end

        def description
          "fail to find a model"
        end
      end

      def fail_a_policy(name)
        FailPolicy.new(name)
      end

      def fail_a_contract(name = "default")
        FailContract.new(name)
      end

      def fail_to_find_the_model
        FailToFindModel.new
      end
    end
  end
end
