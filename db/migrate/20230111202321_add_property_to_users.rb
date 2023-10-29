class AddPropertyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :properties, :jsonb, default: {}
    add_index :users, :properties, using: :gin
  end
end
