class User::Contract::UpdatePassword < Reform::Form
  feature Dry

  property :current_password, virtual: true
  property :password, virtual: true
  property :password_confirmation, virtual: true

  validation name: :default do

    params do
      required(:current_password).filled(:str?)
      required(:password).filled(:str?, min_size?: 8)
      required(:password_confirmation).filled(:str?, min_size?: 8)
    end
  end
end