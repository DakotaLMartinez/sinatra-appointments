class Parent < ActiveRecord::Base
  has_many :parent_students  
  has_many :students, -> { uniq }, through: :parent_students
  has_many :lessons, through: :students
  has_many :booking_requests, through: :students
  has_many :locations, -> { uniq }, through: :booking_requests
  belongs_to :user
end