require_relative "../spec_helper"

require_relative "../../db/migrate/20160225012637_create_roles"

describe 'roles' do
  before do
    sql = "DROP TABLE IF EXISTS roles"
    ActiveRecord::Base.connection.execute(sql)
    CreateRoles.new.change
  end

  it 'has a name' do
    role = Role.new
    role.name = "supreme leader"
    role.save
    expect(Role.where(name: "supreme leader").first).to eq(role)
  end
end