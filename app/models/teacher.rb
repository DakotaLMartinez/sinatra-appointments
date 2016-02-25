class Teacher < ActiveRecord::Base
  has_many :students, through: :lessons  
  has_many :locations, through: :lessons
  has_many :parents, through: :students
  belongs_to :user
end