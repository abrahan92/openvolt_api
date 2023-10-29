class CreateRolePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :role_permissions do |t|
      t.references :role, foreign_key: true
      t.references :permission, foreign_key: true
      t.timestamps
    end

    add_index :role_permissions, [:permission_id, :role_id], unique: true
  end
end
