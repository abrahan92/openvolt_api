class RolePermission::Operation::List < Trailblazer::Operation
  step :list_role_permissions

  private

  def list_role_permissions(options, **)
    options[:model] = RolePermission.all.to_a
  end
end
