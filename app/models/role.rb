class Role < ActiveRecord::Base 
  has_many :users  
  valid_role_names = ["student", "parent", "teacher", "supreme leader"]
  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :name, in: valid_role_names
end