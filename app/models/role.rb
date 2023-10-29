class Role < ApplicationRecord

  class UserOrRoleNotFound < StandardError; end
  class UserRoleNotFound < StandardError; end

  has_and_belongs_to_many :users, :join_table => :users_roles
  has_many :role_permissions, :dependent => :destroy
  has_many :permissions , :through => :role_permissions, :dependent => :destroy
  accepts_nested_attributes_for :role_permissions

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  scopify

  def total_users
    self.users.count
  end
end
