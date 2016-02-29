class Parent < ActiveRecord::Base
  has_many :parent_students  
  has_many :students, -> { uniq }, through: :parent_students
  has_many :lessons, through: :students
  belongs_to :user
end