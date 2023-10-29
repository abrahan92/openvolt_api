class User::Policy::UserNotAllowedSignUp
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, **)
    return false if ['admin', 'super_admin'].include?(params[:properties][:account_type]) || params[:properties][:platform_access] == 'all'
    
    true
  rescue
    false
  end
end
