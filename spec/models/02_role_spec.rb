require "spec_helper"

describe Role do 
  let(:admin) { Role.create(name: "supreme leader") }
  let(:sandra) { User.create(username: "sandra", password: "test123", role_id: admin.id) } 
  let(:dakota) { User.create(username: "dakota", password: "test123", role_id: admin.id) }
  it "has many users" do
    expect(admin.users).to include(sandra, dakota)
  end
end