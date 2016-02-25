class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.string :name 
      t.string :phone_number
      t.string :email
      t.integer :user_id
    end
  end
end
