
# Refactored ErrorHandler to handle multiple errors
# Rescue StandardError acts as a Fallback mechanism to handle any exception
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |e|
          respond(500, "server_error")
        end
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(404, "record_not_found")
        end
        rescue_from Doorkeeper::Errors::TokenExpired do |e|
          respond(400, "permission_denied")
        end
        rescue_from Doorkeeper::Errors::InvalidToken do |e|
          respond(400, "permission_denied")
        end
        rescue_from Doorkeeper::Errors::TokenRevoked do |e|
          respond(400, "permission_denied")
        end
        rescue_from Doorkeeper::Errors::TokenForbidden do |e|
          respond(400, "permission_denied")
        end
        rescue_from Doorkeeper::Errors::TokenUnknown do |e|
          respond(400, "permission_denied")
        end
      end
    end

    private

    def respond(status, key, opts = {})
      render json: { success: false, key: key }, status: status
    end
  end
end