require "spec_helper"

describe Role do 
  let(:admin) { Role.find_or_create_by(name: "supreme leader") }
  let(:sandra) { User.find_or_create_by(username: "sandra", password: "test123", role_id: admin.id) } 
  let(:dakota) { User.find_or_create_by(username: "dakota", password: "test123", role_id: admin.id) }
  it "has many users" do
    expect(admin.users).to include(sandra, dakota)
  end
end