class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :name
      t.string :instruments 
      t.integer :user_id
    end
  end
end
