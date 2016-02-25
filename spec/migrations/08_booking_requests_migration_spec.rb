require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012819_create_booking_requests.rb'

describe 'booking_requests' do
  before do
    sql = "DROP TABLE IF EXISTS booking_requests"
    ActiveRecord::Base.connection.execute(sql)
    CreateBookingRequests.new.change
  end

  it 'has a location, lesson time, duration, price & ids for its location, student, and teacher' do
    sandra = Teacher.find_or_create_by(name: "Sandra Pehrsson")
    buddy = Student.find_or_create_by(name: "Buddy")
    br = BookingRequest.new
    time_format = '%Y-%m-%d %I:%M %p'
    time_string = (Time.now + 60*60*24).strftime(time_format)
    datetime = DateTime.strptime(time_string, time_format)
    br.lesson_time = datetime
    location = Location.find_or_create_by(name: "Santa Monica")
    br.duration = 3600
    br.price = 80
    br.location_id = location.id
    br.student_id = buddy.id
    br.teacher_id = sandra.id
    br.save
    record = BookingRequest.find(br.id)
    expect(record.lesson_time).to eq(datetime)
    expect(record.location).to eq(location)
    expect(record.duration).to eq(3600)
    expect(record.price).to eq(80)
    expect(record.location).to eq(location)
    expect(record.student).to eq(buddy)
    expect(record.teacher).to eq(sandra)
    expect(BookingRequest.where(lesson_time: datetime).first).to eq(br)
  end
end