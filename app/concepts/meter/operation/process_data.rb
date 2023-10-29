class Meter::Operation::ProcessData < Trailblazer::Operation
  class ContractValidationError < StandardError; end
  self["contract.default.class"] = Meter::Contract::Request

  step Rescue(handler: :handler_error) {
    step :validate_params_with_contract
    step Policy::Guard(Meter::Policy::MustExist, name: "must_exist")
    step Policy::Guard(Meter::Policy::DatesMustBeValid, name: "dates_must_be_valid")
    step :set_meter_id
    step :calculate_energy_consumption
    step :calculate_co2_emitted
    step :calculate_fuel_mix
  }

  private

  def validate_params_with_contract(options, params:, **)
    contract = self["contract.default.class"].new(OpenStruct.new(params))

    if contract.validate(params)
      true
    else
      raise Trailblazer::Contract.new(nil, contract.errors.messages)
    end
  end

  def set_meter_id(options, params:, **)
    options[:model] = Struct.new(
      :data
    ).new(Struct.new(
      :meter_id, :start_date, :end_date,
      :energy_consumption, :carbon_emission, :fuel_mix,
      :interval_consumption
    ).new(params[:meter_id], params[:start_date], params[:end_date]))
  end

  def calculate_energy_consumption(options, params:, **)
    Meter::Action::CalculateEnergyConsumption.call(params: params, model: options[:model])
  end

  def calculate_co2_emitted(options, params:, **)
    Meter::Action::CalculateCo2Emitted.call(params: params, model: options[:model])
  end

  def calculate_fuel_mix(options, params:, **)
    Meter::Action::CalculateFuelMixUsed.call(params: params, model: options[:model])
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)
    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
