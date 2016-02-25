class CreateParentStudents < ActiveRecord::Migration
  def change
    create_table :parent_students do |t|
      t.integer :parent_id
      t.integer :student_id
    end
  end
end
