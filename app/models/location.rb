class Location < ActiveRecord::Base 
  has_many :lessons 
  has_many :booking_requests
end