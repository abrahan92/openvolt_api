class User::Policy::ActionAllowedForUser
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, current_user:, params:, **)
    return true if current_user.admin? || current_user.id == params[:id].to_i
    
    false
  rescue
    false
  end
end
