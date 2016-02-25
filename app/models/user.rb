class User < ActiveRecord::Base 
  has_secure_password
  has_many :teachers
  has_many :students
  has_many :parents
  belongs_to :role
end