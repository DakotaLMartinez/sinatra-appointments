require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012838_create_lessons.rb'

describe 'lessons' do
  before do
    sql = "DROP TABLE IF EXISTS lessons"
    ActiveRecord::Base.connection.execute(sql)
    CreateLessons.new.change
  end

  it 'have a location, lesson time, duration, price and corresponding ids for location, student & teacher' do
    sandra = Teacher.find_or_create_by(name: "Sandra Pehrsson")
    buddy = Student.find_or_create_by(name: "Buddy")
    lesson = Lesson.new
    time_format = '%Y-%m-%d %I:%M %p'
    time_string = (Time.now + 60*60*24).strftime(time_format)
    datetime = DateTime.strptime(time_string, time_format)
    lesson.lesson_time = datetime
    location = Location.find_or_create_by(name: "Santa Monica")
    lesson.duration = 3600
    lesson.price = 80
    lesson.location_id = location.id
    lesson.student_id = buddy.id
    lesson.teacher_id = sandra.id
    lesson.save
    record = Lesson.find(lesson.id)
    expect(record.lesson_time).to eq(datetime)
    expect(record.location).to eq(location)
    expect(record.duration).to eq(3600)
    expect(record.price).to eq(80)
    expect(record.location).to eq(location)
    expect(record.student).to eq(buddy)
    expect(record.teacher).to eq(sandra)
    expect(Lesson.where(lesson_time: datetime).first).to eq(lesson)
  end
end