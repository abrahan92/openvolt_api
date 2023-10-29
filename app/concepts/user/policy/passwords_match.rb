class User::Policy::PasswordsMatch
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, **)
    params[:password] == params[:password_confirmation]
  rescue
    false
  end
end
