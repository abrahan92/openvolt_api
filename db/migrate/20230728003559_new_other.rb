class NewOther < ActiveRecord::Migration[7.0]
  def change
    create_table :new_others do |t|
      t.date :birthdate, null: false
      t.string :phone_number, null: false
      
      t.references :user, null: false, foreign_key: true
    end
  end
end
