# frozen_string_literal: true

class ApiController < ApplicationController

  private

  def action_just_allowed_for_admin_error
    unless current_user.admin?
      defaultapi_error!(:action_just_allowed_for_admin, "Action just allowed for admin", 403)
    end
  end
end
