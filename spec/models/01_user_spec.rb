require "spec_helper"

describe User do 
  let(:admin) { Role.find_or_create_by(name: "supreme leader") }
  let(:sandra) { User.create(username: "sandra", password: "test123", name: "Sandra Pehrsson", role_id: admin.id) }
  let(:dakota) { User.create(username: "dakota", password: "test1234", name: "Dakota Martinez") }
  let(:buddy) { Student.create(name: "Buddy", phone_number: "(999) 999-9999", email: "buddy@gmail.com") }
  let(:skipper) { Student.create(name: "Skipper", phone_number: "(123) 456-7890", email: "skip@me.com") }
  let(:ryan) { Student.create(name: "Ryan", phone_number: "(111) 444-7777", email: "ryguy@apple.com") }
  let(:tomorrow) { DateTime.now + 1 }
  let(:next_day) { DateTime.now + 2 }
  let(:next_week) { DateTime.now + 7 }
  let(:lesson1) { Lesson.create(lesson_time: next_day, location: "Santa Monica", duration: 3600, price: 80, student_id: skipper.id, user_id: sandra.id) }
  let(:lesson2) { Lesson.create(lesson_time: next_week, location: "Culver City", duration: 5400, price: 110, student_id: buddy.id, user_id: sandra.id) }
  let(:booking_request1) { BookingRequest.create(lesson_time: tomorrow, duration: 3600, price: 80, location: "Santa Monica", student_id: skipper.id, user_id: sandra.id) }
  let(:booking_request2) { BookingRequest.create(lesson_time: next_day, duration: 5400, price: 110, location: "Culver City", student_id: buddy.id, user_id: sandra.id) }
  let(:booking_request3) { BookingRequest.create(lesson_time: tomorrow, duration: 3600, price: 70, location: "Los Angeles", student_id: ryan.id, user_id: dakota.id) }
 
  it "has a name" do
    expect(sandra.name).to eq("Sandra Pehrsson")
  end
  it "responds to the authenticate method provided by has_secure_password" do 
    expect(sandra.authenticate("test123")).to be_truthy
  end
  
  it "has many lessons" do 
    expect(sandra.lessons).to include(lesson1, lesson2)
    expect(dakota.lessons).to be_empty
  end
  
  it "has many booking requests" do
    expect(sandra.booking_requests).to include(booking_request1, booking_request2)
    expect(dakota.booking_requests).to include(booking_request3)
  end
  
  it "belongs to a role" do 
    expect(sandra.role).to eq(admin)
  end
  
end