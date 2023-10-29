class Admin < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.references :user, null: false, foreign_key: true
    end
  end
end
