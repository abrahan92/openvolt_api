class User::Operation::UpdateProfile < Trailblazer::Operation
  step Rescue(handler: :handler_error) {
    step Policy::Guard(User::Policy::ProfileParamsRequired, name: "profile_params_required")
    step :assign_profile
  }

  private

  def assign_profile(_options, params:, **)
    if params[:model].properties[:account_type] == 'other'
      params[:model].try(:other).update!(params[:profile])
    elsif params[:model].properties[:account_type] == 'new_other'
      params[:model].try(:new_other).update!(params[:profile])
    else
      params[:model].try(:admin).update!(params[:profile])
    end
  end

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
