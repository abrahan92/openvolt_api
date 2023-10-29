module Trailblazer::Extensions::Skill
  def initialize(*containers)
    @mutable_options = {}.with_indifferent_access

    @resolver = Trailblazer::Skill::Resolver.new(
      @mutable_options,
      *containers_to_indifferent_access(containers)
    )
  end

  private

  def containers_to_indifferent_access(containers)
    containers.map do |container|
      if container.is_a? Hash
        container.with_indifferent_access
      else
        container
      end
    end
  end
end
