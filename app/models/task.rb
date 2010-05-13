class Task < ActiveRecord::Base

	module TaskResource
		INVISIBLE = 1
		REGULAR = 2
		EVERYDAY = 3
		REWARDRESOURCE = ["gold"]
		CATAGORY_SET = [1,2,3]
		USER_COUNTER = ["characters", "games","game_attentions", "sharings", "notices", "notifications", "friends", "photos", "statuses", "friend_requests","guild_requests", "event_requests", "guild_invitations", "event_invitations", "poll_invitations", "poke_deliveries", "albums", "blogs", "videos","guilds", "participated_guilds", "polls", "participated_polls"]
#TODO: maybe more resources in  TASKRESOURCE other than USER_COUNTER
		TASKRESOURCE =  USER_COUNTER 

		@key_in_TASKRESOURCE = Proc.new {|k,v| TASKRESOURCE.include?(key.sub(/_count/,'').sub(/_morethan/, '').sub(/_add/,'').downcase)}
		class ComparerTaskUser
			attr_reader :task, :user
			def initialize(t, u)
				@task = t
				@user = u
			end
		
			def compare_req_with_user_counter(req ,num)
				current_info_count = @user.send(req+"_count") 
				return current_info_count >= num
			end
		end
	end

	include TaskResource

	serialize :prerequisite, Hash
	serialize	:requirement,	Hash
	serialize	:description, Hash
	serialize	:reward, Hash

	has_many :user_tasks


	validate 	:description_pattern
	validate	:prerequiste_pattern
	validate	:reward_pattern
	validates_inclusion_of :catagory, :in => CATAGORY_SET

	def get_user_task_tip	user_id
		current_user_task = get_user_task user_id
		if current_user_task
			return current_user_task.show_notification
		end
		return []
	end

#TODO: may optimized
	def get_user_task user_id
		ut = UserTask.first(:conditions => {:user_id => user_id, :task_id => id} )
	end

#TODO
	def can_be_select_by? user_id
#condition 1, time
		task_property_satisfied = is_visible? && is_started? && !is_expired?

#condition 2,3 UserTask structure
		all_user_tasks = UserTask.find_all_by_user_id(user_id)
		current_user_tasks = all_user_tasks.select{|cut| cut.task_id == self.id}
#already select
#in fact its size is 0 or 1
		redo_satisfied = current_user_tasks.all?{|t| t.redo_able?}
#condition 3, prerequisite[:pretask]
		done_task_ids = (all_user_tasks.select{|t| t.is_done?}).map{|t| t.id}
		pretask = self.requirement[:pretask] ||= []
		pretask_satisfied = pretask.all?{ |p| done_task_ids.include? p }
		
#now condition last: userinfo
		cmp = ComparerTaskUser.new(self, User.find(:first, :conditions => {:id => user_id}))
		userinfo = self.requirement[:userinfo] ||= {}
		user_info_satisfied = userinfo.all? do |req, num|
			result = false
			if @key_in_TASKRESOURCE.call(req,num)
				result = cmp(req, num)
			end
			result
		end
		logger.error "task_property_satisfied:#{task_property_satisfied}\n\
						redo_satisfied: #{redo_satisfied}\n\
						pretask_satisfied: #{pretask_satisfied}\n\
						user_info_satisfied: #{user_info_satisfied}"

		
		
		return  task_property_satisfied &&
						redo_satisfied &&
						pretask_satisfied &&
						user_info_satisfied
	end

	#奖励现在只能是gold
	def reward_pattern
		errors.add(:reward, "奖励的格式不对") unless reward.all?{|item, quantity| REWARDRESOURCE.include?(item) && quantity.is_a?(Integer)}
	end


	#用户数据类别是TASKRESOURCE中的一个
	#pretask是数字"与"的关系
	def prerequiste_pattern
		exist_tasks = Task.find(:all, :select => "id")
		exist_taskids = tasks.collect {|t| t.id}

		errors.add(:prerequisite, "字段不能为空") unless prerequisite.is_a?(Hash)

		errors.add(:prerequisite, "用户信息格式不对") unless !prerequisite[:userinfo] || 
		(prerequisite[:userinfo] &&
		  prerequisite[:userinfo].is_a?(Hash) &&	
			 prerequisite[:userinfo].all?(&@key_in_TASKRESOURCE) )

		errors.add(:prerequisite, "前置任务不对") unless !prerequisite[:pretask] || 
		(prerequisite[:pretask] && 
		  prerequisite[:pretask].is_a?(Array) && 
		 	 prerequisite[:pretask].all?{|x| taskids.include? x} )
	end

	#验证任务描述
	#暂时thumbnail可以是空的,以输入默认图片
	#admin才能添加,这个只是简单验证
	def description_pattern
		errors.add(:description, "字段不能为空") unless description.is_a?(Hash)
		errors.add(:description, "标题不能为空") unless description[:title] 
		errors.add(:description, "任务描述不能为空") unless description[:text]
		errors.add(:description, "请添加任务图片") unless description[:image] && description[:image].is_a?(Array)
	end

	def is_regular?
		return true if catagory == Task::REGULAR
	end

	def is_everyday?
		return true if catagory == Task::EVERYDAY
	end

	def is_visible?
		return true if catagory != Task::INVISIBLE
	end

	def is_started?
		return true if starts_at < DateTime.now	
	end

	def is_expired?
		return true if expires_at < DateTime.now
	end
	
end
