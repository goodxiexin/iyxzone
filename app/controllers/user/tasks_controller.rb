class User::TasksController < ApplicationController

#/tasks
	def index
		@alltasks 		= Task.all
		@visibleTask 	= @alltasks.select &:is_visible?
		@myTask				= UserTask.find_all_by_user_id(current_user.id, :include => :task)
		@doneTask			= @myTask.select 	&:is_done?		
	end

#/tasks/id
	def show
		@current_task = Task.find_by_id(params[:id])
		@current_user_task ||= @current_task.get_user_task current_user.id
	end

#/tasks/id/edit
	def edit
		@current_task = Task.find_by_id(params[:id])
		if current_user
			if @current_task.can_be_select_by? current_user
				#@user_task = UserTask.find(:user_id => current_user.id, :task_id => @current_task.id)
				@user_task = UserTask.find(:first, :conditions => ["user_id =? AND task_id =?",current_user.id,  @current_task.id])
				if @user_task
					flash[:notice] = "你已经领取了该任务，赶快完成吧！" 
				else
					@user_task = UserTask.new(:user_id => current_user.id, :task_id => @current_task.id)
					@user_task.init_achievement_and_goal(current_user.id)
					@user_task.starts_at = DateTime.now
					@user_task.save
				end
			else
				flash[:notice] = "你还没达到做该任务的条件！"
			end
		else
			flash[:error] = "请重新登录！"
		end
		redirect_to tasks_url
	end

	#TODO: if task not avail? first two line will corrupt
	def update
		@current_task = Task.find_by_id(params[:id])
		@current_user_task = @current_task.get_user_task current_user.id
		if @current_user_task.is_done?
			flash[:notice] = "已经领取过奖励"	
		elsif @current_user_task.is_achieved?
			@current_user_task.do_complete	
		end
		redirect_to tasks_path
	end


end


