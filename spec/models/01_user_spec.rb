require "spec_helper"

describe User do 
  let(:sandra) { User.create(username: "sandra", password: "test123", name: "Sandra Pehrsson") }
  let(:dakota) { User.create(username: "dakota", password: "test1234", name: "Dakota Martinez") }
  let(:sandra_teacher) { Teacher.create(name: "Sandra Pehrsson", instruments: "voice, piano", user_id: sandra.id) }
  let(:dakota_teacher) { Teacher.create(name: "Dakota Martinez", instruments: "voice, piano", user_id: dakota.id) }
  let(:buddy) { Student.create(name: "Buddy", phone_number: "(999) 999-9999", email: "buddy@gmail.com") }
  let(:skipper) { Student.create(name: "Skipper", phone_number: "(123) 456-7890", email: "skip@me.com") }
  let(:ryan) { Student.create(name: "Ryan", phone_number: "(111) 444-7777", email: "ryguy@apple.com") }
  let(:santa_monica) { Location.create(name: "Santa Monica") }
  let(:culver_city) { Location.create(name: "Culver City") }
  let(:los_angeles) { Location.create(name: "Los Angeles") }
  let(:tomorrow) { DateTime.now + 1 }
  let(:next_day) { DateTime.now + 2 }
  let(:next_week) { DateTime.now + 7 }
  let(:lesson1) { Lesson.create(lesson_time: next_day, location_id: santa_monica.id, duration: 3600, price: 80, student_id: skipper.id, teacher_id: sandra_teacher.id) }
  let(:lesson2) { Lesson.create(lesson_time: next_week, location_id: culver_city.id, duration: 5400, price: 110, student_id: buddy.id, teacher_id: sandra_teacher.id) }
  let(:booking_request1) { BookingRequest.create(lesson_time: tomorrow, duration: 3600, price: 80, location_id: culver_city.id, student_id: skipper.id, teacher_id: sandra_teacher.id) }
  let(:booking_request2) { BookingRequest.create(lesson_time: next_day, duration: 5400, price: 110, location_id: culver_city.id, student_id: buddy.id, teacher_id: sandra_teacher.id) }
  let(:booking_request3) { BookingRequest.create(lesson_time: tomorrow, duration: 3600, price: 70, location_id: los_angeles.id, student_id: ryan.id, teacher_id: dakota_teacher.id) }
 
  it "has a name" do
    expect(sandra.name).to eq("Sandra Pehrsson")
  end
  it "responds to the authenticate method provided by has_secure_password" do 
    expect(sandra.authenticate("test123")).to be_truthy
  end
  
  it "has many students" do 
    expect(sandra.students).to include(lesson1, lesson2)
    expect(dakota.students).to be_empty
  end
  
  it "has many booking requests" do
    expect(sandra.booking_requests).to include(booking_request1, booking_request2)
    expect(dakota.booking_requests).to include(booking_request3)
  end
  
end