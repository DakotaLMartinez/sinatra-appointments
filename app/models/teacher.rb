class Teacher < ActiveRecord::Base
  has_many :lessons
  has_many :booking_requests
  has_many :students, -> { uniq }, through: :lessons
  has_many :locations, -> { uniq }, through: :lessons 
  has_many :parents, -> { uniq }, through: :students 
  belongs_to :user
end