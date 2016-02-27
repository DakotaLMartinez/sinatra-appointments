class Parent < ActiveRecord::Base
  has_many :parent_students  
  has_many :students, -> { uniq }, through: :parent_students
  belongs_to :user
end