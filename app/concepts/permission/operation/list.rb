class Permission::Operation::List < Trailblazer::Operation
  step :list_permissions

  private

  def list_permissions(options, **)
    options[:model] = Permission.all.to_a
  end
end
