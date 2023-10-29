class Permission::Contract::Create < Reform::Form
  feature Dry

  property :action_perform
  property :subject

  validation name: :default do
    params do
      required(:action_perform).filled(:str?, max_size?: 255)
      required(:subject).filled(:str?, max_size?: 255)
    end
  end
end