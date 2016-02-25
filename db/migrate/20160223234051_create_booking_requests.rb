class CreateBookingRequests < ActiveRecord::Migration
  def up
    create_table :booking_requests do |t|
      t.datetime :lesson_time
      t.string :location
      t.integer :duration
      t.integer :price
      t.integer :student_id
      t.integer :user_id
    end
  end
  def down 
    drop_table :booking_requests
  end
end
