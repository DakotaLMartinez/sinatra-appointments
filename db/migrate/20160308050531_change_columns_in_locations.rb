class ChangeColumnsInLocations < ActiveRecord::Migration
  def change
    rename_column :locations, :name, :city
    add_column :locations, :street_address, :string
    add_column :locations, :state, :string
    add_column :locations, :zipcode, :integer
    add_column :locations, :business_name, :string
  end
end
