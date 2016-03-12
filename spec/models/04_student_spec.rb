require "spec_helper"

describe Student do 
  let(:admin) { Role.find_or_create_by(name: "supreme leader") }
  let(:teacher) { Role.find_or_create_by(name: "teacher") }
  let(:parent) { Role.find_or_create_by(name: "parent") }
  let(:student) { Role.find_or_create_by(name: "student") }
  
  let(:sandra) { User.new(username: "sandra", password: "test123", role_id: teacher.id) }
  let(:dakota) { User.new(username: "dakota", password: "test1234", role_id: admin.id) }
  let(:ariel) { User.new(username: "ariel", password: "hellopass", role_id: parent.id) }
  let(:buddy) { User.new(username: "buddy", password: "mypassword", role_id: student.id) }
  
  let(:buddy_student) { Student.create(name: "Buddy", phone_number: "(999) 999-9999", email: "buddy@gmail.com", user_id: buddy.id) }
  let(:skipper_student) { Student.create(name: "Skipper", phone_number: "(123) 456-7890", email: "skip@me.com") }
  let(:ryan_student) { Student.create(name: "Ryan", phone_number: "(111) 444-7777", email: "ryguy@apple.com") }
  let(:randy_student) { Student.create(name: "Randy", phone_number: "(444) 456-8172", email: "randydandy@hotmail.com") }
  
  let(:sandra_teacher) { Teacher.create(name: "Sandra Pehrsson", instruments: "Voice, Piano", user_id: sandra.id) }
  let(:dakota_teacher) { Teacher.create(name: "Dakota Martinez", instruments: "Voice, Piano") }
  
  let(:ariel_parent) { Parent.create(name: "Ariel", phone_number: "(444) 444-4444", email: "ima@mommy.com", user_id: ariel.id) }
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
  let(:lesson5) { Lesson.create( lesson_time: tomorrow_at_two, duration: 5400, price: 80, location_id: santa_monica.id, student_id: buddy_student.id, teacher_id: sandra_teacher.id) }
  let(:lesson6) { Lesson.create( lesson_time: two_days_later_at_two, duration: 3600, price: 85, location_id: santa_monica.id, student_id: ryan_student.id, teacher_id: dakota_teacher.id) }
  let(:lesson7) { Lesson.create( lesson_time: four_days_later, duration: 3600, price: 75, location_id: los_angeles.id, student_id: randy_student.id, teacher_id: sandra_teacher.id) } 
  
  it "has a name" do 
    expect(buddy_student.name).to eq("Buddy")
  end
  
  it "has a phone number" do 
    expect(buddy_student.phone_number).to eq("(999) 999-9999")
  end
  
  it "has an email address" do 
    expect(buddy_student.email).to eq("buddy@gmail.com")
  end
  
  it "has a preferred contact method" do 
    buddy_student.contact_method = "email"
    buddy_student.save
    expect(buddy_student.contact_method).to eq("email")
  end
  
  it "has many lessons" do 
    expect(buddy_student.lessons).to include(lesson2, lesson3, lesson5)
  end
  
  it "has many teachers through lessons" do 
    # loading buddy's lessons creates all of the associations
    # between teachers, students and locations outlined above
    [lesson2, lesson3, lesson5]
    expect(buddy_student.teachers).to include(sandra_teacher)
  end
  
  it "has many locations" do
    # loading buddy's lessons creates all of the associations
    # between teachers, students and locations outlined above
    [lesson2, lesson3, lesson5].each {|i| i.save}
    expect(buddy_student.locations).to include(culver_city, santa_monica)
  end
  
  it "has many parents" do 
    # loading the ParentStudent objects creates the associations
    # between parents and students outlined above
    relationship1
    expect(buddy_student.parents).to include(ariel_parent)
    expect(buddy_student.parents.count).to eq(1)
  end
  
  it "belongs to a user" do 
    buddy.save
    expect(buddy_student.user).to eq(buddy)
  end
  
  context 'validations' do
    
    it "students must have a name, but phone number and email are optional" do 
      new_student = Student.new(name: "")
      expect(new_student.valid?).to be_falsey
      
      named_student = Student.new(name: "ihaveaname")
      expect(named_student.valid?).to be_truthy
    end
    
    it "students only accept valid email addresses" do 
      new_student = Student.new(name: "newstudent", email: "myemail")
      expect(new_student.valid?).to be_falsey
      
      valid_student = Student.new(name: "newstudent", email: "myemail@email.com")
      expect(valid_student.valid?).to be_truthy
    end
    
    it "students only accept valid phone numbers" do 
      new_student = Student.new(name: "newstudent", phone_number: "111 182 12")
      expect(new_student.valid?).to be_falsey 
      
      valid_student = Student.new(name: "newstudent", phone_number: "(123) 456-7890")
      expect(valid_student.valid?).to be_truthy
    end
    
  end
  
end