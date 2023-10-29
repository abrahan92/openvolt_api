class User::Policy::ActionAllowedForAdmin
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, current_user:, params:, **)
    return true if current_user.admin?
    
    false
  rescue
    false
  end
end
