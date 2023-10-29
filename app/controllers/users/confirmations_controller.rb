class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :doorkeeper_authorize!, only: %i[show]
  
  def new
    super
  end

  def create
    super
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.present? && resource.errors.empty?
      render json: { success:true, message: "confirmed" }, status: 200
    else
      render json: { success:false, message: "not_confirmed" }, status: 400
    end
  end
end