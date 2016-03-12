require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012623_create_users.rb'

describe 'users' do
  before do
    sql = "DROP TABLE IF EXISTS users"
    ActiveRecord::Base.connection.execute(sql)
    CreateUsers.new.change
  end

  it 'have a username' do
    user = User.new
    user.username = "Steven"
    user.password = "safepassword"
    user.role = Role.find_or_create_by(name: "supreme leader")
    user.save
    expect(User.where(username: "Steven").first).to eq(user)
  end
end