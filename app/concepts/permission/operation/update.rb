class Permission::Operation::Update < Trailblazer::Operation
  self['contract.default.class'] = Permission::Contract::Create

  step Model(Permission, :find_by)
  step Rescue(handler: :handler_error) {
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  }

  private

  def handler_error(exception, options)
    mapped_exception = ApiError::DefaultApiError.for(exception)

    options["result.defaultapi.rescue"] = Dry::Monads.Failure(mapped_exception)
  end
end
