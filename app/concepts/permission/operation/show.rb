class Permission::Operation::Show < Trailblazer::Operation
  step Model(Permission, :find_by)
end
