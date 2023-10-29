# spec/concepts/role/operation/delete_role_to_user_spec.rb

RSpec.describe Role::Operation::DeleteRoleToUser, type: :operation do
  let(:user) { create(:user, :other_profile) }
  let(:role) { create(:role) }
  let(:params) { { user_role: { user_id: user.id, role_id: role.id } } }

  describe '#call' do
    subject(:result) { described_class.call(params) }

    context 'when both user and role exist' do
      before { user.roles << role }

      it 'deletes the role from the user' do
        expect { result }.to change { user.roles.count }.by(-1)
        expect(result).to be_success
        expect(user.reload.roles).not_to include(role)
      end
    end

    context 'when the user does not exist' do
      before { params[:user_role][:user_id] = -1 }

      it 'does not delete the role and returns a failure' do
        expect { result }.not_to change { Role.count }
        expect(result).to be_failure
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(Role::UserOrRoleNotFound)
      end
    end

    context 'when the role does not exist' do
      before { params[:user_role][:role_id] = -1 }

      it 'does not delete the role and returns a failure' do
        expect { result }.not_to change { user.roles.count }
        expect(result).to be_failure
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(Role::UserOrRoleNotFound)
      end
    end

    context 'when the role is not already added to the user' do
      it 'does not delete the role and returns a failure' do
        expect { result }.not_to change { user.roles.count }
        expect(result).to be_failure
        expect(result['result.defaultapi.rescue'].failure.error).to be_a(Role::UserRoleNotFound)
      end
    end
  end
end