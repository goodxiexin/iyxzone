class CreateUserTasks < ActiveRecord::Migration
  def self.up
    create_table :user_tasks do |t|
			t.integer	:user_id
			t.integer	:task_id
			t.datetime		:starts_at
			t.datetime		:done_at
			t.text		:achievement
			t.text		:goal
      t.datetime	:expires_at
			#t.integer	:state 		#doing, achieved, get_reward			
    end
  end

  def self.down
    drop_table :user_tasks
  end
end
