module ApiError::DefaultApiError
  def self.for(error)
    return ApiError::DefaultApiError::Base.new(error) unless handled?(error)

    error_handler, error_options = @errors[error.class].values_at(:handler, :options)
    
    if error_options.blank?
      error_handler.new(error)
    else
      error_handler.new(error, error_options)
    end
  end

  def self.handled?(error)
    @errors[error.class].present?
  end

  def self.handle_error(*errors, **options)
    @errors ||= Hash.new do |hash, key|
      hash.detect { |sk, _| key.ancestors.include?(sk) }.try(:last)
    end

    errors.each do |error|
      handler = options.delete(:with) || ApiError::DefaultApiError::Base

      @errors[error] = { handler: handler, options: options }
    end
  end

  # A helper for error testing
  def self.options_for_key(key)
    (@errors.values.detect { |v| v[:options][:key] == key.to_s.downcase.to_sym } || {})[:options]
  end

  handle_error ActiveRecord::RecordNotUnique,
              key: :record_not_unique,
              message: "Record already exists",
              code: 422

  handle_error ActiveRecord::RecordNotFound,
              key: :record_not_found,
              message: "Record doesn't exists",
              code: 404

  handle_error ActiveRecord::InvalidForeignKey,
              key: :foreign_key_violation,
              message: "Foreign key violation",
              code: 422

  handle_error Doorkeeper::Errors::TokenUnknown,
              key: :access_token_invalid,
              message: "Access token is invalid",
              code: 401

  handle_error Role::UserOrRoleNotFound,
              key: :user_or_role_not_found,
              message: "User or role not found",
              code: 422

  handle_error Role::UserRoleNotFound,
              key: :user_role_not_found,
              message: "This user doesn't have this role",
              code: 422

  handle_error User::WrongCurrentPassword,
              key: :wrong_current_password,
              message: "Wrong current password",
              code: 422
  
  handle_error User::CreateProfileError,
              key: :create_profile_error,
              message: "Error creating profile",
              code: 422

  handle_error User::ConfirmUserError,
              key: :confirm_user_error,
              message: "Error confirming user",
              code: 422

  handle_error User::UpdateProfileError,
              key: :update_profile_error,
              message: "Error updating profile",
              code: 422

  handle_error User::CreateOnStripeError,
              key: :create_on_stripe_error,
              message: "Error creating user on stripe",
              code: 422

  handle_error User::CreateAccountOnStripeError,
              key: :create_user_account_on_stripe_error,
              message: "Error creating user account on stripe",
              code: 422

  handle_error User::LinkAccountOnStripeError,
              key: :link_user_account_on_stripe_error,
              message: "Error linking user account on stripe",
              code: 422

  handle_error User::DeleteAccountOnStripeError,
              key: :delete_user_account_on_stripe_error,
              message: "Error deleting user account on stripe",
              code: 422
  handle_error Trailblazer::Contract,
              key: :bad_request,
              message: "BadRequest",
              code: 400
end
