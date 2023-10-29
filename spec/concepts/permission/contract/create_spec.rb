# spec/concepts/permission/contract/create_spec.rb

RSpec.describe Permission::Contract::Create, type: :contract do
  subject(:form) { described_class.new(Permission.new) }

  describe 'Validation' do
    context 'when all attributes are valid' do
      let(:valid_attributes) { { action_perform: 'read', subject: 'Document' } }

      it 'is valid' do
        form.validate(valid_attributes)
        expect(form).to be_valid
      end
    end

    context 'when action_perform is not provided' do
      let(:invalid_attributes) { { action_perform: nil, subject: 'Document' } }

      it 'is not valid' do
        form.validate(invalid_attributes)
        expect(form).not_to be_valid
        expect(form.errors[:action_perform]).to include('must be filled')
      end
    end

    context 'when action_perform is too long' do
      let(:invalid_attributes) { { action_perform: 'a' * 256, subject: 'Document' } }

      it 'is not valid' do
        form.validate(invalid_attributes)
        expect(form).not_to be_valid
        expect(form.errors[:action_perform]).to include('size cannot be greater than 255')
      end
    end

    context 'when subject is not provided' do
      let(:invalid_attributes) { { action_perform: 'read', subject: nil } }

      it 'is not valid' do
        form.validate(invalid_attributes)
        expect(form).not_to be_valid
        expect(form.errors[:subject]).to include('must be filled')
      end
    end

    context 'when subject is too long' do
      let(:invalid_attributes) { { action_perform: 'read', subject: 'a' * 256 } }

      it 'is not valid' do
        form.validate(invalid_attributes)
        expect(form).not_to be_valid
        expect(form.errors[:subject]).to include('size cannot be greater than 255')
      end
    end
  end
end