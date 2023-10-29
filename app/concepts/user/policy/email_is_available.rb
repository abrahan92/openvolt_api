class User::Policy::EmailIsAvailable
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, **)
    User.find_by(email: params.dig(:email)).nil?
  rescue
    false
  end
end
