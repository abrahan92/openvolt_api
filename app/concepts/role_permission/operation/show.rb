class RolePermission::Operation::Show < Trailblazer::Operation
  step Model(RolePermission, :find_by)
end
