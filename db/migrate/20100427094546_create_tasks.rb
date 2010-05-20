class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
			t.text	:prerequisite
			t.text	:requirement
			t.text	:reward
			t.text	:description
			t.integer	:catagory, :default => 2		#everyday, single 
														#should only belongs to 1
			t.datetime	:starts_at, :default => DateTime.now
			t.datetime	:expires_at
			t.integer		:duration
			t.integer	:state 	#released, doing, drop 
												#for holiday task or new user task

    end
  end

  def self.down
    drop_table :tasks
  end
end
