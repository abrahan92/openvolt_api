require "disposable/twin/parent"
require "reform/form/coercion"
require "reform/form/dry"

Trailblazer::Operation.extend(Trailblazer::Extensions::Operation)
Trailblazer::Operation::Result.include(Trailblazer::Extensions::Operation::Result)

Trailblazer::Skill.prepend(Trailblazer::Extensions::Skill)
Reform::Contract.prepend(Trailblazer::Extensions::Reform::Errors)