class ParentStudent < ActiveRecord::Base 
  belongs_to :parent
  belongs_to :student
end