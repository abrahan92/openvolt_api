module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = authenticate!
    end

    protected

    def authenticate!
      user = User.find_by(id: doorkeeper_token.try(:resource_owner_id))

      user || reject_unauthorized_connection
    end
    # this will still allow expired tokens
    # you will need to check if token is valid with something like
    #  doorkeeper_token&.acceptable?(@_doorkeeper_scopes)
    def doorkeeper_token
      ::Doorkeeper.authenticate(request)
    end
  end
end
