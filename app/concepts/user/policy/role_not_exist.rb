class User::Policy::RoleNotExist
    extend Uber::Callable
  
    pattr_initialize :options, :params
  
    def self.call(_options, params:, **)
        return true if params[:roles].nil?

        params[:roles].all? { |role| Role.find(role).present? }
    rescue
        false
    end
  end
  