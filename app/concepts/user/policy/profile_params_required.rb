class User::Policy::ProfileParamsRequired
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, **)
    user = User.find(params[:model].id)

    return false if user.nil? || (params[:profile].nil? && user.properties[:account_type] != 'admin')

    true
  rescue
    false
  end
end
