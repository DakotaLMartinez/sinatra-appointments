require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012732_create_parents.rb'

describe 'parents' do
  before do
    sql = "DROP TABLE IF EXISTS parents"
    ActiveRecord::Base.connection.execute(sql)
    CreateParents.new.change
  end

  it 'have a name, phone number, email & associated user id' do
    user = User.create(name: "mommy", password: "imamommy")
    parent = Parent.new
    parent.name = "Mommy"
    parent.phone_number = "(123) 456-8907"
    parent.email = "email@me.com"
    parent.user_id = user.id
    parent.save
    expect(Parent.where(name: "Mommy").first).to eq(parent)
  end
end