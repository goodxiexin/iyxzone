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
		if (@current_task = Task.find_by_id(params[:id]))
			logger.error current_user.inspect
			@user_task = UserTask.find(:first, :conditions => ["user_id =? AND task_id =?", 
			current_user.id,  
			@current_task.id])
			logger.error ("--"*20) + "PARAMS[:redo_check]: #{params[:redo_check]}"
			if @current_task.can_be_select_by?(current_user, (params[:redo_check]? true :false))
				UserTask.delete_all({:user_id => current_user.id, :task_id => @current_task.id})
				@user_task = UserTask.new(:user_id => current_user.id, :task_id => @current_task.id)
				@user_task.init_user_task(current_user.id)
				@user_task.save
				flash[:notice] = "开始完成任务吧！" 
			else
				if @user_task
					flash[:notice] = "不能重复领取任务！" 
				else
					flash[:notice] = "你无法领取该任务！"
				end
			end
		else
			flash[:notice] = "错误的任务id"
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


