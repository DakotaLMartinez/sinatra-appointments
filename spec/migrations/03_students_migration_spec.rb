require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012703_create_students.rb'
require_relative '../../db/migrate/20160303013058_add_contact_method_to_students.rb'

describe 'students' do
  before do
    sql = "DROP TABLE IF EXISTS students"
    ActiveRecord::Base.connection.execute(sql)
    CreateStudents.new.change
    AddContactMethodToStudents.new.change
  end

  it 'have a name, email, phone number & associated user id' do
    user = User.create(name: "iamuser", password: "funnytaste")
    student = Student.new
    student.name = "Buddy"
    student.email = "buddy@gmail.com"
    student.phone_number = "(999) 999-9999"
    student.contact_method = "email"
    student.user_id = user.id
    student.save
    expect(Student.where(name: "Buddy").first).to eq(student)
  end
end