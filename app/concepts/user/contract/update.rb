class User::Contract::Update < Reform::Form
  feature Dry

  property :name
  property :lastname
  property :properties, populator: ->(represented:, fragment:, **) do
    self.properties = represented.model.properties.merge(fragment)
  end
  property :picture
  property :password
  property :roles, virtual: true, populator: ->(represented:, fragment:, **) do
    self.roles = fragment
  end
  property :profile, virtual: true, populator: ->(represented:, fragment:, **) do
    self.profile = represented.model.profile.attributes.merge(fragment).except('id', 'user_id')
  end
  
  validation name: :default do

    params do
      optional(:name).maybe(:str?)
      optional(:lastname).maybe(:str?)
      optional(:properties).maybe(:hash?)
      optional(:roles).maybe(:array?)
      optional(:profile).maybe(:hash?)
      optional(:password).maybe(:str?, min_size?: 8)
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
                  # values[:profile] = Coerce::Profile::OtherCoercer.coerce(values[:profile])

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