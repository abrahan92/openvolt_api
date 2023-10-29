class Other < ActiveRecord::Migration[7.0]
  def change
    create_table :others do |t|
      t.date :birthdate, null: false
      t.string :phone_number, null: false
      
      t.references :user, null: false, foreign_key: true
    end
  end
end
