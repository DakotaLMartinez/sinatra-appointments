require "spec_helper" 

describe Teacher do 
  let(:admin) { Role.find_or_create_by(name: "supreme leader") }
  let(:teacher) { Role.find_or_create_by(name: "teacher") }
  let(:parent) { Role.find_or_create_by(name: "parent") }
  let(:student) { Role.find_or_create_by(name: "student") }
  
  let(:sandra) { User.new(username: "sandra", password: "test123", role_id: teacher.id) }
  let(:sandra_user) { sandra.save ? sandra : User.find_by(username: "sandra") }
  let(:dakota) { User.new(username: "dakota", password: "test1234", role_id: admin.id) }
  let(:dakota_user) { dakota.save ? dakota : User.find_by(username: "dakota") }
  let(:ariel) { User.new(username: "ariel", password: "hellopass", role_id: parent.id) }
  let(:ariel_user) { ariel.save ? ariel : User.find_by(username: "ariel") }
  let(:buddy) { User.new(username: "buddy", password: "mypassword", role_id: student.id) }
  let(:buddy_user) { buddy.save ? buddy : User.find_by(username: "buddy") }
  
  let(:buddy_student) { Student.create(name: "Buddy", phone_number: "(999) 999-9999", email: "buddy@gmail.com", user_id: buddy_user.id) }
  let(:skipper_student) { Student.create(name: "Skipper", phone_number: "(123) 456-7890", email: "skip@me.com") }
  let(:ryan_student) { Student.create(name: "Ryan", phone_number: "(111) 444-7777", email: "ryguy@apple.com") }
  let(:randy_student) { Student.create(name: "Randy", phone_number: "(444) 456-8172", email: "randydandy@hotmail.com") }
  
  let(:sandra_teacher) { Teacher.create(name: "Sandra Pehrsson", instruments: "Voice, Piano", user_id: sandra_user.id) }
  let(:dakota_teacher) { Teacher.create(name: "Dakota Martinez", instruments: "Voice, Piano", user_id: dakota_user.id) }
  
  let(:ariel_parent) { Parent.create(name: "Ariel", phone_number: "(444) 444-4444", email: "ima@mommy.com", user_id: ariel_user.id) }
  let(:daddy_parent) { Parent.create(name: "Daddy", phone_number: "(555) 555-5555", email: "ima@daddy.com") }
  
  let(:relationship1) { ParentStudent.create(parent_id: ariel_parent.id, student_id: buddy_student.id) }
  let(:relationship2) { ParentStudent.create(parent_id: daddy_parent.id, student_id: skipper_student.id) }
  let(:relationship3) { ParentStudent.create(parent_id: ariel_parent.id, student_id: skipper_student.id) }
  
  let(:santa_monica) { Location.create(city: "Santa Monica") }
  let(:culver_city) { Location.create(city: "Culver City") }
  let(:los_angeles) { Location.create(city: "Los Angeles") }
  
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
  
  it "has many lessons" do 
    [sandra_teacher, dakota_teacher].each { |i| i.save }
    expect(sandra_teacher.lessons).to include(lesson1, lesson2, lesson3, lesson4, lesson5, lesson7)
    expect(dakota_teacher.lessons).to include(lesson6)
  end
  
  it "has many students through lessons" do
    [sandra_teacher, dakota_teacher, lesson1, lesson2, lesson3, lesson4, lesson5, lesson6, lesson7].each { |i| i.save }
    expect(sandra_teacher.students).to include(skipper_student, buddy_student, randy_student)
    expect(sandra_teacher.students.length).to eq(3)
    expect(dakota_teacher.students).to include(ryan_student)
  end
  
  it "has many locations through lessons" do 
    [sandra_teacher, dakota_teacher, lesson1, lesson2, lesson3, lesson4, lesson5, lesson6, lesson7].each { |i| i.save }
    expect(sandra_teacher.locations).to include(santa_monica, culver_city, los_angeles)
    expect(sandra_teacher.locations.length).to eq(3)
    expect(dakota_teacher.locations).to include(santa_monica)
  end
  
  it "has many parents through students" do 
    [sandra_teacher, dakota_teacher, relationship1, relationship2, relationship3, lesson1, lesson2, lesson3, lesson4, lesson5, lesson6, lesson7].each { |i| i.save }
    expect(sandra_teacher.parents).to include(ariel_parent, daddy_parent)
    expect(sandra_teacher.parents.length).to eq(2)
  end
  
  it "belongs to a user" do 
    [sandra_user, ariel, buddy].each { |i| i.save }
    [sandra_teacher, ariel_parent, buddy_student].each { |i| i.save }
    expect(sandra_teacher.user).to eq(sandra_user)
    expect(sandra_user.teachers).to include(sandra_teacher)
    expect(ariel_parent.user).to eq(ariel_user)
    expect(ariel_user.parents).to include(ariel_parent)
    expect(buddy_student.user).to eq(buddy_user)
    expect(buddy_user.students).to include(buddy_student)
  end
  
  context "validations" do 
     
     it "teachers must have a name" do 
        new_user = User.create(username: "newuser", password: "newpassword", role_id: teacher.id)
        new_teacher = Teacher.new(instruments: "guitar, drums", user_id: new_user.id)
        expect(new_teacher.valid?).to be_falsey
     end
     
     it "teachers must have a list of instruments that they teach" do 
         new_user = User.create(username: "newuser", password: "newpassword", role_id: teacher.id)
         new_teacher = Teacher.new(name: "newteacher", user_id: new_user.id)
         expect(new_teacher.valid?).to be_falsey
     end
     
     it "teachers must belong to a user" do 
        new_teacher = Teacher.new(name: "newteacher", instruments: "guitar, drums")
        expect(new_teacher.valid?).to be_falsey
     end
      
  end
  
end