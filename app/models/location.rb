class Location < ActiveRecord::Base 
  has_many :lessons 
end