class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username 
      t.string :password_digest
      t.string :name
      t.integer :role_id
    end
  end
end
