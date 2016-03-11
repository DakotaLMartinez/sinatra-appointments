require "spec_helper"

describe User do 
  let(:admin) { Role.create(name: "supreme leader") }
  let(:teacher) { Role.create(name: "teacher") }
  let(:parent) { Role.create(name: "parent") }
  let(:student) { Role.create(name: "student") }
  
  let(:sandra) { User.create(username: "sandra", password: "test123", role_id: teacher.id) }
  let(:dakota) { User.create(username: "dakota", password: "test1234", role_id: admin.id) }
  let(:ariel) { User.create(username: "ariel", password: "hellopass", role_id: parent.id) }
  let(:buddy) { User.create(username: "buddy", password: "mypassword", role_id: student.id) }
  
  let(:buddy_student) { buddy.students.create(name: "Buddy", phone_number: "(999) 999-9999", email: "buddy@gmail.com", user_id: buddy.id) }
  let(:skipper_student) { Student.create(name: "Skippter", phone_number: "(123) 456-7890", email: "skip@me.com") }
  let(:ryan_student) { Student.create(name: "Ryan", phone_number: "(111) 444-7777", email: "ryguy@apple.com") }
  let(:randy_student) { Student.create(name: "Randy", phone_number: "(444) 456-8172", email: "randydandy@hotmail.com") }
  
  let(:sandra_teacher) { Teacher.create(name: "Sandra Pehrsson", instruments: "Voice, Piano", user_id: sandra.id) }
  let(:dakota_teacher) { Teacher.create(name: "Dakota Martinez", instruments: "Voice, Piano") }
  
  let(:ariel_parent) { Parent.create(name: "Ariel", phone_number: "(444) 444-4444", email: "ima@mommy.com", user_id: ariel.id) }
  let(:daddy_parent) { Parent.create(name: "Daddy", phone_number: "(555) 555-5555", email: "ima@daddy.com") }
  
  let(:relationship1) { ParentStudent.create(parent_id: ariel_parent.id, student_id: buddy_student.id) }
  let(:relationship2) { ParentStudent.create(parent_id: daddy_parent.id, student_id: skipper_student.id) }
  let(:relationship3) { ParentStudent.create(parent_id: ariel_parent.id, student_id: skipper_student.id) }
  
  let(:santa_monica) { Location.create(name: "Santa Monica") }
  let(:culver_city) { Location.create(name: "Culver City") }
  let(:los_angeles) { Location.create(name: "Los Angeles") }
  
  let(:tomorrow_at_ten) { DateTime.now.midnight + 34.hours }
  let(:two_days_later) { DateTime.now.midnight + 59.hours }
  let(:next_week) { DateTime.now.midnight + 14.hours + 7.days }
  let(:in_two_weeks) { DateTime.now.midnight + 16.hours + 14.days }
  let(:four_days_later) { DateTime.now.midnight + 18.hours + 4.days }
  let(:two_days_later_at_two) { DateTime.now.midnight + 14.hours + 2.days }
  let(:tomorrow_at_two) { DateTime.now.midnight + 38.hours }
  let(:tomorrow_at_three) { DateTime.now.midnight + 39.hours }
  
  let(:lesson1) { Lesson.create( lesson_time: two_days_later, duration: 3600, price: 80, location_id: santa_monica.id, student_id: skipper_student.id, teacher_id: sandra_teacher.id) }
  let(:lesson2) { Lesson.create( lesson_time: next_week, duration: 5400, price: 110, location_id: culver_city.id, student_id: buddy_student.id, teacher_id: sandra_teacher.id) }
  let(:lesson3) { Lesson.create( lesson_time: in_two_weeks, duration: 5400, price: 110, location_id: culver_city.id, student_id: buddy_student.id, teacher_id: sandra_teacher.id) }
  let(:lesson4) { Lesson.create( lesson_time: tomorrow_at_ten, duration: 3600, price: 80, location_id: santa_monica.id, student_id: randy_student.id, teacher_id: sandra_teacher.id) }
  let(:lesson5) { Lesson.create( lesson_time: tomorrow_at_two, duration: 5400, price: 80, location_id: culver_city.id, student_id: buddy_student.id, teacher_id: sandra_teacher.id) }
  let(:lesson6) { Lesson.create( lesson_time: two_days_later_at_two, duration: 3600, price: 85, location_id: santa_monica.id, student_id: ryan_student.id, teacher_id: dakota_teacher.id) }
  let(:lesson7) { Lesson.create( lesson_time: four_days_later, duration: 3600, price: 75, location_id: los_angeles.id, student_id: randy_student.id, teacher_id: sandra_teacher.id) }
  
  it "has a username" do
    expect(sandra.username).to eq("sandra")
  end
  
  it "responds to the authenticate method provided by has_secure_password" do 
    expect(sandra.authenticate("test123")).to be_truthy
  end
  
  it "belongs to a role" do 
    expect(sandra.role).to eq(teacher)
    expect(dakota.role).to eq(admin)
  end
  
  it "has many students" do 
    # association won't register properly unless the user object is saved first
    buddy.save
    expect(buddy.students).to include(buddy_student)
  end
  
  it "has many teachers" do 
    # association won't register properly unless the user object is saved first
    sandra.save
    expect(sandra.teachers).to include(sandra_teacher)
  end
  
  it "has many parents" do 
    # association won't register properly unless the user object is saved first
    ariel.save
    expect(ariel.parents).to include(ariel_parent)
  end
  
end