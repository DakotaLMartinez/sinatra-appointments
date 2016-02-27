class Student < ActiveRecord::Base
  has_many :lessons
  has_many :booking_requests
  has_many :teachers, -> { uniq }, through: :lessons
  has_many :locations, -> { uniq }, through: :lessons
  has_many :parent_students
  has_many :parents, -> { uniq }, through: :parent_students
  belongs_to :user
end