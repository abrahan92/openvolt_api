class User::Contract::Create < Reform::Form
  feature Dry

  property :email
  property :password
  property :provider
  property :name
  property :lastname
  property :properties
  property :picture
  property :roles, virtual: true
  property :profile, virtual: true

  validation name: :default do
    params do
      required(:name).filled(:str?)
      required(:lastname).filled(:str?)
      required(:email).filled(:str?)
      required(:password).filled(:str?, min_size?: 8)
      required(:roles).filled(:array?)
      required(:profile).filled(:hash?)
      optional(:provider).maybe(:str?)
      required(:properties).filled(:hash?)
      optional(:picture)
    end

    rule(:properties) do
      if values[:properties].present?
        schema = 'config/schemas/user_properties.json'

        error_messages = JSON::Validator.fully_validate(schema, values[:properties].to_json)

        if error_messages.present?
          error_messages.each do |msg|
            sanitized_msg = msg.gsub(/ in schema file:\/\/\/[^,]+/, '') # Remove the schema file path
            if match = sanitized_msg.match(/did not contain a required property of '([^']+)'/)
              attribute_name = match[1]
              key(attribute_name.to_sym).failure(sanitized_msg) # add error to the specific attribute
            else
              key.failure(sanitized_msg) # If it's not a missing attribute error, add it as a general profile error
            end
          end
        end
      end
    end

    rule(:roles) do
      if values[:roles].present?
        values[:roles] = Coercer.array_of_strings_to_integers(values[:roles])

        key.failure('roles must be an array of integer') unless values[:roles].all? { |role| role.is_a?(Integer) }
      end
    end

    rule(:profile) do
      if values[:profile].present? && values[:properties][:account_type].present? && values[:properties][:account_type].in?(%w[other new_other])

        schema = case values[:properties][:account_type]
                when "other"
                  values[:profile] = Coerce::Profile::OtherCoercer.coerce(values[:profile])

                  'config/schemas/other_profile.json'
                when "new_other"
                  values[:profile] = Coerce::Profile::NewOtherCoercer.coerce(values[:profile])

                  'config/schemas/new_other_profile.json'
                end
        
        error_messages = JSON::Validator.fully_validate(schema, values[:profile].to_json)

        # Assuming error_messages is an array
        if error_messages.present?
          error_messages.each do |msg|
            sanitized_msg = msg.gsub(/ in schema file:\/\/\/[^,]+/, '') # Remove the schema file path
            if match = sanitized_msg.match(/did not contain a required property of '([^']+)'/)
              attribute_name = match[1]
              key(attribute_name.to_sym).failure(sanitized_msg) # add error to the specific attribute
            else
              key.failure(sanitized_msg) # If it's not a missing attribute error, add it as a general profile error
            end
          end
        end
      end
    end
  end
end