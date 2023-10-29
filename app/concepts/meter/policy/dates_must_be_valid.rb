class Meter::Policy::DatesMustBeValid
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, **)
    from = params[:start_date].to_date
    to = params[:end_date].to_date

    return true if from < to
    
    false
  rescue
    false
  end
end
