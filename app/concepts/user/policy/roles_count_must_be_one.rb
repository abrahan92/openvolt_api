class User::Policy::RolesCountMustBeOne
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, model:, **)
    return true if params[:roles].nil?

    params[:roles].present? && params[:roles].count.eql?(1)
  rescue
    false
  end
end
