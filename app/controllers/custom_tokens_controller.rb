class CustomTokensController < Doorkeeper::TokensController
  include Authentication::Cookies
  include ActionController::Cookies

  def create
    authorization = strategy.authorize
    
    if authorization.status == :ok
      revoke_previous_token(authorization) if params[:grant_type] == 'refresh_token'
      sign_cookies(authorization)
    end

    render json: authorization.body, status: authorization.status
  end

  def revoke
    if doorkeeper_token && !doorkeeper_token.revoked? && doorkeeper_token.revoke
      render json: { success: true, key: "signed_out" }, status: 200
    else
      render json: { success: false, key: "something_went_wrong" }, status: 400
    end
  end

  private

  def revoke_previous_token(authorization)
    if authorization.token.previous_refresh_token.present?
      previous_token = Doorkeeper::AccessToken.by_refresh_token(authorization.token.previous_refresh_token)
      previous_token.revoke if previous_token.present? && !previous_token.revoked?
    end
  end

  def user_params
    params.permit(:email, :client_id, :client_secret, :access_token, :refresh_token, :grant_type)
  end

  def parse_token_response(user, token)
    {
      name: user.name,
      lastname: user.lastname,
      email: user.email,
      id: user.id,
      application_id: token.application_id,
      access_token: token.token,
      refresh_token: token.refresh_token,
      expires_in: token.expires_in,
      revoked_at: token.revoked_at,
      created_at: token.created_at,
      scopes: token.scopes,
      picture: params[:provider] == 'google' ? @google_payload['picture'] : user.picture_url,
      provider: user.provider,
      previous_refresh_token: token.previous_refresh_token,
      properties: user.properties,
      permissions: user.roles.map do |role|
        role.permissions.select(:action_perform, :subject).except(:id).map do |permission|
          {
            action_perform: permission.action_perform,
            subject: permission.subject
          }
        end
      end.flatten.uniq,
      default_role: user.roles.first
    }
  end
end