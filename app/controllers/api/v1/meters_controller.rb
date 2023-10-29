class Api::V1::MetersController < ApiController
  def consumption
    endpoint Meter::Operation::ProcessData do
      on_success { represent(Meter::Representer::Data) }
      on_failed_contract       { failed_contract_error }
      on_failed_with_exception { defaultapi_error_from_exception }
      on_failed_policy(:dates_must_be_valid) { dates_must_be_valid }
      on_failed_policy(:must_exist) { meter_not_found }
    end
  end

  private

  def dates_must_be_valid
    defaultapi_error!(:dates_must_be_valid, message: "Dates must be valid")
  end

  def meter_not_found
    defaultapi_error!(:meter_not_found, message: "Meter not found")
  end

  def failed_contract_error
    record_invalid_error
  end
end