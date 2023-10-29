class Role::Operation::Show < Trailblazer::Operation
  step Model(Role, :find_by)
end
