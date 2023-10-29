module ApiError::DefaultApiError
  class InvalidTransition < ApiError::DefaultApiError::Base
    def initialize(error)
      @error   = error
      @key     = :invalid_transition
      @message = error.message
      @code    = 422
    end
  end
end
