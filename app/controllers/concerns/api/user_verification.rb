module Api
  module UserVerification
    GOOGLE_CLIENT_ID = Settings.providers.google.client_id

    def validate_user
      @user = User.find_by(email: user_params[:email])

      if @user.nil?
        api_error(422, "unregisted_email", { error: "UNREGISTERED_EMAIL" })
      end

    rescue => e
      api_default_error({ error: e.message })
    end

    def validate_provider
      provider = params[:provider]
      token = params[:assertion]

      if provider == 'google' && token.present?
        @google_payload = verify_google_token(token)
        @google_email = @google_payload["email"]

        verify_user = User.find_by(email: @google_email)

        if verify_user && verify_user.provider != provider && params[:type] == 'login'
          api_error(422, "mismatch_provider_and_regular_user_login", { error: "MISMATCH_PROVIDER_AND_REGULAR_USER_LOGIN" })
        elsif verify_user && params[:type] == 'register'
          api_error(422, "already_registered", { error: "EMAIL_ALREADY_REGISTERED" })
        elsif verify_user.nil? && params[:type] == 'login'
          api_error(422, "unregisted_email", { error: "UNREGISTERED_EMAIL" })
        end
      else
        api_error(422, "mismatch_provider_and_regular_user_login", { error: "MISMATCH_PROVIDER_AND_REGULAR_USER_LOGIN" })
      end
    rescue => e
      api_default_error({ error: e.message })
    end

    def verify_google_token(google_token)
      validator = GoogleIDToken::Validator.new
      payload = validator.check(google_token, GOOGLE_CLIENT_ID)
    end
  end
end

