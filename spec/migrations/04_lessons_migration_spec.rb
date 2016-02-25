require_relative '../spec_helper'

require_relative '../../db/migrate/20160224005351_create_lessons.rb'

describe 'lesson' do
  before do
    sql = "DROP TABLE IF EXISTS lessons"
    ActiveRecord::Base.connection.execute(sql)
    CreateLessons.new.up
    @lesson = Lesson.new
    time_format = '%Y-%m-%d %I:%M %p'
    time_string = (Time.now + 60*60*24).strftime(time_format)
    @datetime = DateTime.strptime(time_string, time_format)
    @lesson.lesson_time = @datetime
    @lesson.location = "Santa Monica"
    @lesson.duration = 3600
    @lesson.price = 80
    @lesson.save
  end

  it 'has a location, lesson time, duration and price' do
    record = Lesson.find(@lesson.id)
    expect(record.lesson_time).to eq(@datetime)
    expect(record.location).to eq("Santa Monica")
    expect(record.duration).to eq(3600)
    expect(record.price).to eq(80)
    expect(Lesson.where(lesson_time: @datetime).first).to eq(@lesson)
  end
end