class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :access_token
      t.string :hashtags
      t.string :mentions
      t.string :usernames
      t.string :content  
    end
  end
end
