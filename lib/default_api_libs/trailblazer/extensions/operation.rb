module Trailblazer::Extensions
  module Operation
    def Finder(constant: nil, name: "default") # rubocop:disable Naming/MethodName
      step = ->(_input, options) do
        ActiveSupport::Notifications.instrument("finder.trailblazer",
                                                options: options,
                                                constant: constant,
                                                name: name) do |instrumentation|
          options[:model] = (options["finder.#{name}.class"] || constant).(options)
          options["result.model"] = Trailblazer::Operation::Result.new(options[:model].present?, {})
          instrumentation[:result] = options["result.model"]
          options["result.model"].success?
        end
      end
      [step, { name: "finder.#{name}" }]
    end

    def Enqueue(callable) # rubocop:disable Naming/MethodName
      step = ->(input, options) do
        CurrentOperationContainer.commands << -> do
          input.send(callable, options, **options)
        end
      end

      [step, { name: "defaultapi.macro.Enqueue.#{callable}" }]
    end

    def ExecuteQueueIfRootOperation # rubocop:disable Naming/MethodName
      step = ->(_input, _options) do
        return true unless CurrentOperationContainer.operation_nesting_level.zero?
        CurrentOperationContainer.execute_commands
      end

      [step, { name: "defaultapi.macro.ExecuteQueueIfRootOperation" }]
    end

    def Map(mapper) # rubocop:disable Naming/MethodName
      step = ->(_input, options) { options["params"] = mapper.(options["params"]) }

      [step, { name: "mapper.default" }]
    end

    def MergeContractErrorsFromAR(name: "default") # rubocop:disable Naming/MethodName
      step = ->(_input, options) do
        return unless options["model"]
        options["model"].errors.each { |k, v| options["contract.#{name}"].errors.add(k, v) }
      end
      [step, { name: "defaultapi_contract.#{name}.merge_errors_from_ar" }]
    end

    # Accepts a proc that gets evaluated when the operation is logged, see OperationLogSubscriber
    # The proc is run with operation result object, and allows to evaluate log context tags
    # The block is not evaluated when it defined in the operation, but only at the operation end
    #
    # success LogContext(-> (options) { options[:model] })
    #
    def LogContext(log_contex_proc) # rubocop:disable Naming/MethodName
      step = ->(_input, options) do
        options["log_contexts"] ||= []
        begin
          options["log_contexts"] << log_contex_proc.call(options)
        rescue => e
          options["log_contexts"] << "Error_#{e.class.name}"
        end
      end
      [step, { name: "add_log_context" }]
    end

    # This is a helper to add log tags at the end of the operation no matter what is the outcome
    # Be careful to not use keyword arguments in case there is a failure and they are not set
    # Only do this:
    #
    # log_context ->(options) { options["model"] }
    #
    # And not
    #
    # log_context ->(options, model:) { model: }
    #
    # as the second will blow up if the model step does not execute for some reason
    def log_context(log_contex_proc, *)
      success LogContext(log_contex_proc)
      failure LogContext(log_contex_proc)
    end

    def add_execute_queue_if_root_operation_step
      step ExecuteQueueIfRootOperation() if CurrentOperationContainer.operation_nesting_level.zero?
    end

    class OperationFailedError < RuntimeError; end
  end
end
