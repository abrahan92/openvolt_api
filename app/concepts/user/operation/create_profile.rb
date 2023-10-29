class User::Operation::CreateProfile < Trailblazer::Operation
  step Policy::Guard(User::Policy::ProfileParamsRequired, name: "profile_params_required")
  step :assign_profile

  private

  def assign_profile(_options, params:, **)
    if params[:model].properties[:account_type] == 'other'
      params[:model].other = Other.new(params[:profile])
    elsif params[:model].properties[:account_type] == 'new_other'
      params[:model].new_other = NewOther.new(params[:profile])
    else
      params[:model].admin = Admin.new!(params[:profile])
    end

    true
  end
end
