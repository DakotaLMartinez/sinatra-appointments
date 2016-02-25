class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.integer :user_id
    end
  end
end
