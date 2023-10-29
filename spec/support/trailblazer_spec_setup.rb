# spec/support/trailblazer_spec_setup.rb

RSpec.configure do |config|
  config.before(:suite) do
    module Trailblazer
      class Operation
        class << self
          alias original_call call

          def call(params = {}, options = {})
            options[:current_user] ||= RSpec.configuration.current_user
            original_call(params, options)
          end
        end
      end
    end
  end

  config.after(:suite) do
    # Restore original behavior
    module Trailblazer
      class Operation
        class << self
          alias call original_call
        end
      end
    end
  end
end