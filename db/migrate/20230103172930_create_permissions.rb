class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :action_perform
      t.string :subject

      t.timestamps null: false
    end

    add_index :permissions, [:action_perform, :subject], unique: true
  end
end
