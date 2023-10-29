module Trailblazer::Handler
  class DefaultApiError
    extend Uber::Callable

    def self.call(exception, options)
      raise exception if raisable?(exception)
      defaultapi_error = ApiError::DefaultApiError.for(exception)
      options["result.defaultapi.rescue"] = Dry::Monads.Failure(defaultapi_error)
    end

    def self.raisable?(exception)
      !ApiError::DefaultApiError.handled?(exception) && (Rails.env.development? || Rails.env.test?)
    end
  end
end