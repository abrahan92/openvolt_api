require 'types/types'

class Meter::Contract::Request < Reform::Form
  feature Dry

  property :start_date
  property :end_date
  property :granularity

  validation name: :default do
    params do
      required(:start_date).filled(:str?, format?: /\A\d{4}-\d{2}-\d{2}\z/)
      required(:end_date).filled(:str?, format?: /\A\d{4}-\d{2}-\d{2}\z/)
      required(:granularity).filled(:str?, included_in?: ['hh'])
    end
  end
end