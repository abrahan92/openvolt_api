class User::Policy::MustBeSuperAdmin
  extend Uber::Callable
  
  pattr_initialize :options, :params
  
  def self.call(_options, current_user:, **)
    current_user.has_role?(:super_admin)
  rescue
    false
  end
end