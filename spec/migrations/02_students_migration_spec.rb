require_relative '../spec_helper'

require_relative '../../db/migrate/20160223233612_create_students.rb'

describe 'student' do
  before do
    sql = "DROP TABLE IF EXISTS students"
    ActiveRecord::Base.connection.execute(sql)
    CreateStudents.new.up
  end

  it 'has a name, email and phone number' do
    student = Student.new
    student.name = "Buddy"
    student.email = "buddy@gmail.com"
    student.phone_number = "(999) 999-9999"
    student.save
    expect(Student.where(name: "Buddy").first).to eq(student)
  end
end