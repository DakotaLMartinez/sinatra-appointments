class AddContactMethodToStudents < ActiveRecord::Migration
  def change
    add_column :students, :contact_method, :string
  end
end
