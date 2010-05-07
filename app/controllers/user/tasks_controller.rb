class User::TasksController < ApplicationController

#/user/tasks
	def index
		@alltasks 		= Task.find(:all)
		@visibleTask 	= @alltasks.collect &:is_visible?
		@myTask				= UserTask.find_all_by_user_id(current_user.id, :include => :task)
		@doneTask			= @myTask.collect 	&:is_done?		
	end

# /user/tasks/id
	def show
		@current_task = Task.find_by_id(:id)
	end
end


