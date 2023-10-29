class Trailblazer::DefaultApiEndpoint
  NullResult = Naught.build do |config|
    config.mimic Trailblazer::Operation::Result
    config.singleton
    config.predicates_return false
  end

  attr_private :actions, :mapper, :extra_dependencies
  pattr_initialize :operation, :run_options, :controller do
    @actions = []
    @mapper = ->(params) { params }
    @extra_dependencies = []
    def controller._run_options(original_options)
      super.merge(@run_options)
    end
  end
  delegate :result, to: :controller

  AVAILABLE_ACTIONS = {
    on_success: -> { result.success? },
    on_failure: -> { result.failure? },
    on_failed_policy: ->(name = "default") { failure_for?("result.policy.#{name}") },
    on_failed_contract: ->(name = "default") { failure_for?("result.contract.#{name}") },
    on_failed_with_exception: -> { failure_for?("result.defaultapi.rescue") },
    on_model_not_found: -> { failure_for?("result.model") }
  }.with_indifferent_access.freeze

  def self.call(operation, run_options = {}, &block)
    controller = eval("self", block.binding, __FILE__, __LINE__)
    new(operation, run_options, controller).call(&block)
  end

  def call(&block)
    instance_eval(&block)
    # controller params is an instance of ActionController::Parameters - convert to hash
    params_from_strong = controller.params.to_unsafe_h.with_indifferent_access
    controller.instance_variable_set(:@normalized_params, mapper.call(params_from_strong))
    controller.instance_variable_set(:@extra_dependencies, extra_dependencies)
    controller.instance_variable_set(:@run_options, run_options)
    controller.instance_eval("run #{operation}, @normalized_params, *@extra_dependencies",
                             __FILE__, __LINE__ - 1)
    (actions.detect { |condition, _| condition.call } || [-> {}]).last.call
  end

  private

  def failure_for?(key)
    (controller.result[key] || NullResult.instance).failure?
  end

  def add_action(name, *args, &block)
    actions << [-> { instance_exec(*args, &AVAILABLE_ACTIONS[name]) },
                -> { controller.instance_eval(&block) }]
  end

  def method_missing(method_name, *args, &block)
    return super unless AVAILABLE_ACTIONS[method_name]
    add_action(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    AVAILABLE_ACTIONS[method_name] || super
  end

  def use_mapper(mapper)
    @mapper = mapper
  end

  def use_contract(contract)
    @extra_dependencies << { "contract.default.class": contract }
  end

  def use_finder(finder)
    @extra_dependencies << { "finder.default.class": finder }
  end
end
