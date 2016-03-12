require "spec_helper"

describe Role do 
  let(:admin) { Role.find_or_create_by(name: "supreme leader") }
  let(:sandra) { User.create(username: "sandra", password: "test123", role_id: admin.id) } 
  let(:dakota) { User.create(username: "dakota", password: "test123", role_id: admin.id) }
  
  it "has many users" do
    expect(admin.users).to include(sandra, dakota)
  end
  
  context "validations" do 
    
    it "only accepts valid user roles (student, parent, teacher or supreme leader)" do 
      astronaut = Role.new(name: "astronaut!")
      expect(astronaut.valid?).to be_falsey
    end
    
    it "maintains uniqueness of user role names" do 
      admin2 = Role.new(name: "supreme leader")
      expect(admin2.valid?).to be_falsey
    end
    
  end
  
end