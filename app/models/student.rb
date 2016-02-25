class Student < ActiveRecord::Base
  has_many :lessons
  has_many :booking_requests
  has_many :teachers, through: :lessons
  has_many :parent_students
  has_many :parents, through: :parent_students
  belongs_to :user
end