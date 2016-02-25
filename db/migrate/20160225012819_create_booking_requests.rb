class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|
      t.datetime :lesson_time
      t.integer :duration
      t.integer :price
      t.integer :location_id
      t.integer :student_id 
      t.integer :teacher_id
    end
  end
end
