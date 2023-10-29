class RolifyCreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end

    add_index :users_roles, [:user_id, :role_id], unique: true
    add_index :roles, [:name], unique: true
    add_foreign_key "users_roles", "roles", column: "role_id"
    add_foreign_key "users_roles", "users", column: "user_id"
  end
end
