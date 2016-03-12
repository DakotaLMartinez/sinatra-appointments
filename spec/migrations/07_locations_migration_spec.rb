require_relative '../spec_helper'

require_relative '../../db/migrate/20160225012850_create_locations.rb'
require_relative '../../db/migrate/20160308050531_change_columns_in_locations.rb'

describe 'locations' do
  before do
    sql = "DROP TABLE IF EXISTS locations"
    ActiveRecord::Base.connection.execute(sql)
    CreateLocations.new.change
    ChangeColumnsInLocations.new.change
  end
  before(:each) do 
    @location = Location.find_or_create_by(city: "Santa Monica", street_address: "1901 Santa Monica Blvd", state: "California", zipcode: 90404, business_name: "Santa Monica Music Center")
  end

  it 'have a city' do
    expect(Location.find(@location.id).city).to eq("Santa Monica")
  end
  
  it "have a street address" do 
    expect(Location.find(@location.id).street_address).to eq("1901 Santa Monica Blvd")
  end
  
  it "have a state" do 
    expect(Location.find(@location.id).state).to eq("California")
  end
  
  it "have a zipcode" do 
    expect(Location.find(@location.id).zipcode).to eq(90404)
  end
  
  it "have a business name" do 
    expect(Location.find(@location.id).business_name).to eq("Santa Monica Music Center")
  end
  
end