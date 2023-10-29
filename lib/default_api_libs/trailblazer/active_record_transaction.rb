class Trailblazer::ActiveRecordTransaction
  extend Uber::Callable

  # Returns the block result (result of block.call) on success
  # if raising an error here then AR.transaction{} returns nil
  def self.call(*, &block)
    ApplicationRecord.transaction do
      block.call.tap do |result|
        raise ActiveRecord::Rollback unless result.first == Pipetree::Railway::Right
      end
    end
  end
end
