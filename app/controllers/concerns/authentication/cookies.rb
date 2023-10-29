module Authentication
  module Cookies
    def sign_cookies(authorization)
      cookies.signed[:defaultapi_access_token] = { 
        value: authorization.token.token, 
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict,
        expires: Time.now + authorization.token.expires_in.seconds
      }
  
      cookies.signed[:defaultapi_refresh_token] = {
        value: authorization.token.refresh_token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict,
        expires: Time.now + authorization.token.expires_in.seconds
      }
    end
  end
end