class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.datetime :lesson_time 
      t.integer :duration 
      t.integer :price 
      t.integer :location_id
      t.integer :student_id
      t.integer :teacher_id
    end
  end
end
