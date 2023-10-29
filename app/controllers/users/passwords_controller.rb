# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :doorkeeper_authorize!, only: %i[update create]
  prepend_before_action :require_no_authentication

  def create
    user = User.find_by(email: user_params[:email])

    if user && user.send_reset_password_instructions
      render json: { success:true, message: "email_sent" }, status: 200
    else
      render json: { success:false, message: "email_not_sent" }, status: 400
    end
  rescue => e
    render json: { success:false, message: e.message }, status: 400
  end

  def update
    user = User.find_by(reset_password_token: user_params[:reset_password_token])

    if user.reset_password(user_params[:password], user_params[:password_confirmation])
      user.confirm if !user.confirmed?

      render json: { success:true, message: "password_updated" }, status: 200
    elsif user_params[:password] != user_params[:password_confirmation]
      render json: { success:false, message: "passwords_do_not_match" }, status: 400
    else
      render json: { success:false, message: "password_not_updated" }, status: 400
    end
  rescue => e
    render json: { success:false, message: e.message }, status: 400
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end