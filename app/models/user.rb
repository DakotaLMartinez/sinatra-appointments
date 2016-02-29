class User < ActiveRecord::Base 
  has_secure_password
  has_many :teachers
  has_many :students
  has_many :parents
  belongs_to :role
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+\z/
  validates :username, presence: true, length: { maximum: 20 },
                                        format: { with: VALID_USERNAME_REGEX },
                                        uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :role, presence: true
end