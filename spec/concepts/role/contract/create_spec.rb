# spec/concepts/role/contract/create_spec.rb

RSpec.describe Role::Contract::Create do
  subject(:form) { described_class.new(Role.new) }

  describe "Validation" do
    context "when valid attributes" do
      let(:attributes) do
        {
          name: "admin",
          permission_ids: [1, 2, 3]
        }
      end

      it "is valid" do
        form.validate(attributes)

        expect(form).to be_valid
      end
    end

    context "when invalid attributes" do
      let(:attributes) do
        {
          name: "invalid_name",
          permission_ids: [1, "invalid", 3]
        }
      end

      it "is invalid" do
        form.validate(attributes)

        expect(form).not_to be_valid
        expect(form.errors.messages).to include(
          name: ["must be one of: super_admin, admin, new_other, other"],
          permission_ids: { 1 => ["must be an integer"] }
        )
      end
    end

    context "when missing required attributes" do
      it "is invalid" do
        form.validate({})

        expect(form).not_to be_valid
        expect(form.errors.messages).to include(
          name: ["must be filled", "must be one of: super_admin, admin, new_other, other"],
          permission_ids: ["must be filled", "size cannot be less than 1"]
        )
      end
    end
  end
end
