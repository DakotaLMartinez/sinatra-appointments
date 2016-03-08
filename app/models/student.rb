class Student < ActiveRecord::Base
  has_many :lessons
  has_many :booking_requests
  has_many :teachers, -> { uniq }, through: :lessons
  has_many :locations, -> { uniq }, through: :lessons
  has_many :parent_students
  has_many :parents, -> { uniq }, through: :parent_students
  belongs_to :user
  
  validates_presence_of :name
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, message: 'Please enter a valid email address'}, allow_blank: true
  validates :phone_number, format: { with: /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/, message: "Please enter a valid phone number (123) 456-7890" }, allow_blank: true
  validates_inclusion_of :contact_method, in: ["phone", "email"], allow_nil: true
end