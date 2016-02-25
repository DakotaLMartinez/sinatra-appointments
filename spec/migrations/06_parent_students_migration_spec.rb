require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012758_create_parent_students.rb'

describe 'parent_students' do
  before do
    sql = "DROP TABLE IF EXISTS parent_students"
    ActiveRecord::Base.connection.execute(sql)
    CreateParentStudents.new.change
  end

  it 'have a parent_id and a student_id' do
    user = User.create(name: "mommy", password: "imamommy")
    parent = Parent.create(name: "Mommy", phone_number: "(123) 456-8907", email: "email@me.com", user_id: user.id)
    student = Student.create(name: "Buddy", email: "buddy@gmail.com", phone_number: "(999) 999-9999")
    relationship = ParentStudent.create(parent_id: parent.id, student_id: student.id)
    expect(ParentStudent.where(parent_id: parent.id).first).to eq(relationship)
  end
end