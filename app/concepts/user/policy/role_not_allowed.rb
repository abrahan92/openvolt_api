class User::Policy::RoleNotAllowed
    extend Uber::Callable
  
    pattr_initialize :options, :params
  
    def self.call(options, params:, **)
        role = Role.where(id: params[:roles]).first

        return true if (params[:properties] && role && role.name.eql?(params[:properties][:account_type])) ||
            (role && options[:model] && role.name.eql?(options[:model].properties[:account_type])) ||
            params[:roles].nil? && options[:model].default_role.present?

        false
    rescue
        false
    end
  end
  