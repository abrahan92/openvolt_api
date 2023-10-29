class User::Policy::UserCanCreateUser
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, current_user:, **)
    return true if current_user.admin?
    
    false
  rescue
    false
  end
end
