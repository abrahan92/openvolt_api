class RolePermission::Policy::RoleAndPermissionMustExists
  extend Uber::Callable

  pattr_initialize :options, :params

  def self.call(_options, params:, **)
    role = Role.find_by(id: params.dig(:role_permission, :role_id))
    permission = Permission.find_by(id: params.dig(:role_permission, :permission_id))

    role.present? && permission.present?
  end
end
