ActiveRecord::Base.transaction do

  # Create Doorkeeper application
  if Doorkeeper::Application.find_by(name: "Web App").nil?
    Doorkeeper::Application.create!(name: "Web App", redirect_uri: "", scopes: "")
  end

  if Doorkeeper::Application.find_by(name: "Mobile App").nil?
    Doorkeeper::Application.create!(name: "Mobile App", redirect_uri: "", scopes: "")
  end

  if Doorkeeper::Application.find_by(name: "Openvolt App").nil?
    Doorkeeper::Application.create!(name: "Openvolt App", uid: "test_api_key_client_id", secret: "test_api_key_client_secret", redirect_uri: "", scopes: "")
  end
  
  # Create roles
  if Role.count == 0
    ['super_admin', 'admin', 'new_other', 'other'].each do |role_name|
      Role.create! name: role_name
    end
  end

  # Create permissions
  if RolePermission.count == 0

    ['home', 'users', 'roles', 'permissions', 'energy_meter'].each do |section|
      ['read', 'create', 'update', 'delete'].each do |action_perform|
        Permission.create! action_perform: action_perform, subject: section
      end
    end
  end

  # Add permissions to roles
  if RolePermission.count == 0
    # super_admin
    ['home', 'users', 'roles', 'permissions', 'energy_meter'].each do |section|
      ['read', 'create', 'update', 'delete'].each do |action_perform|
        RolePermission.create! role_id: Role.find_by(name: 'super_admin').id, permission_id: Permission.find_by(action_perform: action_perform, subject: section).id
      end
    end
  end

  # Create a user 1
  if User.find_by(email: "mendozaabrahan@gmail.com").nil?
    user = User.create!(
      email: "mendozaabrahan@gmail.com",
      password: "12345678",
      password_confirmation: "12345678",
      properties: {
        account_type: "super_admin",
        platform_access: "all"
      }
    )
    user.confirm
    user.add_role :admin
    user.add_role :super_admin

    admin = Admin.create!(
      user_id: user.id
    )
  end

  # Create a user => other 3
  if User.find_by(email: "other@gmail.com").nil?
    user = User.create!(
      email: "other@gmail.com",
      password: "12345678",
      password_confirmation: "12345678",
      properties: {
        account_type: "other",
        platform_access: "mobile"
      }
    )
    user.confirm
    user.add_role :other

    other = Other.create!(
      user_id: user.id,
      birthdate: "1990-01-01",
      phone_number: "123456789"
    )
  end

  # Create a user => new_other 4
  if User.find_by(email: "new_other@gmail.com").nil?
    user = User.create!(
      email: "new_other@gmail.com",
      password: "12345678",
      password_confirmation: "12345678",
      properties: {
        account_type: "new_other",
        platform_access: "mobile"
      }
    )
    user.confirm
    user.add_role :new_other

    new_other = NewOther.create!(
      user_id: user.id,
      birthdate: "1990-01-01",
      phone_number: "123456789"
    )
  end

  # Create a user => openvolt user
  if User.find_by(email: "test@openvolt.com").nil?
    user = User.create!(
      email: "test@openvolt.com",
      password: "12345678",
      password_confirmation: "12345678",
      properties: {
        account_type: "super_admin",
        platform_access: "all"
      }
    )
    user.confirm
    user.add_role :super_admin

    admin = Admin.create!(
      user_id: user.id
    )
  end
end