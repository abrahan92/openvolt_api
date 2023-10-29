class Role::Operation::List < Trailblazer::Operation
  step :list_roles

  private

  def list_roles(options, **)
    options[:model] = Role.all.to_a
  end
end
