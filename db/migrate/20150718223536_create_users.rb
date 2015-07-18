class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :access_token
      t.string :filters
      
    end
    
  end
  
end