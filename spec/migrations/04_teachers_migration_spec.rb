require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012717_create_teachers.rb'

describe 'teachers' do
  before do
    sql = "DROP TABLE IF EXISTS teachers"
    ActiveRecord::Base.connection.execute(sql)
    CreateTeachers.new.change
  end

  it 'have a name, instruments & associated user id' do
    user = User.create(name: "sandra", password: "test123")
    teacher = Teacher.new
    teacher.name = "Sandra Pehrsson"
    teacher.instruments = "Piano, Voice"
    teacher.user_id = user.id
    teacher.save
    expect(Teacher.where(name: "Sandra Pehrsson").first).to eq(teacher)
  end
end