require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012850_create_locations.rb'

describe 'locations' do
  before do
    sql = "DROP TABLE IF EXISTS locations"
    ActiveRecord::Base.connection.execute(sql)
    CreateLocations.new.change
  end

  it 'have a name' do
    location = Location.find_or_create_by(name: "Santa Monica")
    expect(Location.where(name: "Santa Monica").first).to eq(location)
  end
end