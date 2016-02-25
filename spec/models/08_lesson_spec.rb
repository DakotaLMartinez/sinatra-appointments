require "spec_helper"

describe Lesson do
  let(:sandra) { User.create(username: "sandra", password: "test123", name: "Sandra Pehrsson") }
  let(:dakota) { User.create(username: "dakota", password: "test1234", name: "Dakota Martinez") }
  let(:buddy) { Student.create(name: "Buddy", phone_number: "(999) 999-9999", email: "buddy@gmail.com") }
  let(:skipper) { Student.create(name: "Skipper", phone_number: "(123) 456-7890", email: "skip@me.com") }
  let(:ryan) { Student.create(name: "Ryan", phone_number: "(111) 444-7777", email: "ryguy@apple.com") }
  let(:tomorrow) { DateTime.now + 1 }
  let(:next_day) { DateTime.now + 2 }
  let(:next_week) { DateTime.now + 7 }
  let(:lesson1) { Lesson.create(lesson_time: next_day, location: "Santa Monica", duration: 3600, price: 80, student_id: skipper.id, user_id: sandra.id) }
  let(:lesson2) { Lesson.create(lesson_time: next_week, location: "Culver City", duration: 5400, price: 110, student_id: buddy.id, user_id: sandra.id) }
 
  it "has a lesson time" do 
    expect(lesson1.lesson_time).to eq(next_day)
  end
  
  it "has a location" do 
    expect(lesson1.location).to eq("Santa Monica")
  end
  
  it "has a duration" do 
    expect(lesson1.duration).to eq(3600)
  end
  
  it "has a price" do 
    expect(lesson1.price).to eq(80)
  end
  
  it "belongs to a student" do 
    expect(lesson1.student).to eq (skipper)
    expect(lesson2.student_id).to eq(buddy.id)
  end
  
  it "belongs to a user" do 
    expect(lesson1.user).to eq(sandra)
    expect(lesson1.user_id).to eq(sandra.id)
  end
  
end