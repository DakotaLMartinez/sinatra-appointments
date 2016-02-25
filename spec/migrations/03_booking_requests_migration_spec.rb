require_relative '../spec_helper'

require_relative '../../db/migrate/20160223234051_create_booking_requests.rb'

describe 'booking request' do
  before do
    sql = "DROP TABLE IF EXISTS booking_requests"
    ActiveRecord::Base.connection.execute(sql)
    CreateBookingRequests.new.up
    @br = BookingRequest.new
    time_format = '%Y-%m-%d %I:%M %p'
    time_string = (Time.now + 60*60*24).strftime(time_format)
    @datetime = DateTime.strptime(time_string, time_format)
    @br.lesson_time = @datetime
    @br.location = "Santa Monica"
    @br.duration = 3600
    @br.price = 80
    @br.save
  end

  it 'has a location, lesson time, duration and price' do
    record = BookingRequest.find(@br.id)
    expect(record.lesson_time).to eq(@datetime)
    expect(record.location).to eq("Santa Monica")
    expect(record.duration).to eq(3600)
    expect(record.price).to eq(80)
    expect(BookingRequest.where(lesson_time: @datetime).first).to eq(@br)
  end
end