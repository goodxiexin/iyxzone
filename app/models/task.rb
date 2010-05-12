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

		@key_in_TASKRESOURCE = Proc.new {|k,v| TASKRESOURCE.include?(key.sub(/_count/).downcase)}
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
		logger.error ut.inspect
		ut
	end

#TODO
	def can_be_select_by? user_id
		#if pretask in UserTask.get_all_user_task user_id and
		# current not in 
		# and userinfo satisfied
		return true
	end

	#奖励现在只能是gold
	def reward_pattern
		errors.add(:reward, "奖励的格式不对") unless reward.all?{|item, quantity| REWARDRESOURCE.include?(item) && quantity.is_a?(Integer)}
	end


	#用户数据类别是TASKRESOURCE中的一个
	#pretask是数字"与"的关系
	def prerequiste_pattern
		errors.add(:prerequisite, "字段不能为空") unless prerequisite.is_a?(Hash)
		errors.add(:prerequisite, "用户信息格式不对") unless !prerequisite[:userinfo] || 
		(prerequisite[:userinfo] &&
		  prerequisite[:userinfo].is_a?(Hash) &&	
		   #prerequisite[:userinfo].all?{|k,v| k.to_s.humanize.split(' ').any?{|x| TASKRESOURCE.include?(x.downcase)}} )
			 prerequisite[:userinfo].all?(&@key_in_TASKRESOURCE) )
		errors.add(:prerequisite, "前置任务不对") unless !prerequisite[:pretask] || 
		(prerequisite[:pretask] && 
		  prerequisite[:pretask].is_a?(Hash) && 
		 	 prerequisite[:pretask].all?{|x| x.is_a?(Integer)} )
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
	
end
