class Task < ActiveRecord::Base

	module TaskResource
		CANDO, CANNOTDO, DONE, EXPIRED, ACHIEVED, DOING  = 1,2,3,4,5,6
		INVISIBLE,REGULAR,EVERYDAY = 1,2,3
		REWARDRESOURCE = ["gold"]
		CATAGORY_SET = [1,2,3]
		USER_COUNTER = ["characters", "games","game_attentions", "sharings", "notices", "notifications", "friends", "photos", "statuses", "friend_requests","guild_requests", "event_requests", "guild_invitations", "event_invitations", "poll_invitations", "poke_deliveries", "albums", "blogs", "videos","guilds", "participated_guilds", "polls", "participated_polls"]
#TODO: maybe more resources in  TASKRESOURCE other than USER_COUNTER
		TASKRESOURCE =  USER_COUNTER 

		@@key_in_TASKRESOURCE = Proc.new {|k,v| TASKRESOURCE.include?(@@get_key_in_TASKRESOURCE.call(k))}
		@@get_key_in_TASKRESOURCE = Proc.new {|k| k.sub(/_count/,'').sub(/_morethan/, '').sub(/_add/,'').downcase}

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
		else
      return []
    end
	end

#TODO: may optimized
	def get_user_task user_id
		ut = UserTask.first(:conditions => {:user_id => user_id, :task_id => id} )
	end

  def pretask_satisfy? uts
    done_task_ids = (uts.select { |t| t.is_done?}).map{|t| t.task_id}
    pretask_ids = self.prerequisite[:pretask] ||= []
    pretask_ids.all?{ |p| done_task_ids.include? p }
  end


#for UserTask instance has been created: set redo_satisfied = true
	def can_be_select_by? user_id, redo_satisfied=false
#condition 1, time
		task_property_satisfied = is_visible? && is_started? && !is_expired?
		all_user_tasks = UserTask.find_all_by_user_id(user_id)
#condition 2: current_user_task 是否能重做
    current_user_tasks = all_user_tasks.select{|cut| cut.task_id == self.id}
		redo_satisfied ||= current_user_tasks.all?{|t| t.redo_able?}
#condition 3: prerequisite[:pretask]
		pretask_satisfied = pretask_satsify? all_user_task
#condition 4: userinfo
    judge = ResourceJudge.new(self, User.find(:first, :condition => {:id => user_id}))
		user_info_satisfied = judge.prerequistite_user_info_satisfy?
		logger.error "\ntask_property_satisfied:#{task_property_satisfied}\n\
						redo_satisfied: #{redo_satisfied}\n\
						pretask_satisfied: #{pretask_satisfied}\n\
						user_info_satisfied: #{user_info_satisfied}"
		return  task_property_satisfied &&
						redo_satisfied &&
						pretask_satisfied &&
						user_info_satisfied
	end

#TODO: 过期重做的话can_be_selec_by? 条件要放宽
	def check_state(user_id, redo_check=false)
		if can_be_select_by?(user_id, redo_check)
#可以做
				return 1
		end
		unless ut = get_user_task(user_id)
#不能做，原因未定
				return 2
		else
			if ut.is_done?
				return 3
			elsif ut.is_expired?
				retrun 4
			elsif ut.is_achieved?
				return 5
			else
				return 6
			end
		end

	end

	#奖励现在只能是gold
	def reward_pattern
		errors.add(:reward, "奖励的格式不对") unless reward.all?{|item, quantity| REWARDRESOURCE.include?(item) && quantity.is_a?(Integer)}
	end


	#用户数据类别是TASKRESOURCE中的一个
	#pretask是数字"与"的关系
	def prerequiste_pattern
		exist_tasks = Task.find(:all, :select => "id")
		exist_taskids = exist_tasks.collect {|t| t.id}

		errors.add(:prerequisite, "字段不能为空") unless prerequisite.is_a?(Hash)

		errors.add(:prerequisite, "用户信息格式不对") unless !prerequisite[:userinfo] || 
		(prerequisite[:userinfo] &&
		  prerequisite[:userinfo].is_a?(Hash) &&	
			 prerequisite[:userinfo].all?(&@key_in_TASKRESOURCE) )

		errors.add(:prerequisite, "前置任务还不存在") unless !prerequisite[:pretask] || 
		(prerequisite[:pretask] && 
		  prerequisite[:pretask].is_a?(Array) && 
		 	 prerequisite[:pretask].all?{|x| exist_taskids.include? x} )
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
