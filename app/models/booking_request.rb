class BookingRequest < ActiveRecord::Base 
  belongs_to :student
  belongs_to :teacher
  belongs_to :location
end