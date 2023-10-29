# spec/user/contract/update_password_spec.rb

RSpec.describe User::Contract::UpdatePassword do
  subject { described_class.new(User.new) }

  describe 'validations' do
    context 'when valid params are passed' do
      let(:params) do
        {
          current_password: 'currentpassword123',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      end

      it 'is valid' do
        subject.validate(params)
        expect(subject.errors.messages).to be_empty
      end
    end

    context 'when missing required fields' do
      it 'is invalid' do
        subject.validate({})
        expect(subject.errors.messages.keys).to include(:current_password, :password, :password_confirmation)
      end
    end

    context 'when password length is less than 8 characters' do
      let(:params) do
        {
          current_password: 'currentpassword123',
          password: 'short',
          password_confirmation: 'short'
        }
      end

      it 'is invalid' do
        subject.validate(params)
        expect(subject.errors.messages[:password]).to include('size cannot be less than 8')
        expect(subject.errors.messages[:password_confirmation]).to include('size cannot be less than 8')
      end
    end
  end
end
