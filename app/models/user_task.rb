class UserTask < ActiveRecord::Base
	include Task::TaskResource
	
	belongs_to :task
	belongs_to :user

	serialize	:achievement, Hash


	validates_presence_of	:user_id
	validates_presence_of :task_id
	validate	:achievement_pattern


	def init_user_task user_id
		init_achievement user_id
		starts_at = DataTime.now
#TODO: set expires_at
		save
	end

	def init_achievement user_id
		user = User.find(user_id)
#"albums", "blogs","videos" counters are virtual attributes which are not save in DB
		h = {}
		USER_COUNTER.each do |item|
			h[item] = user.send(item+"_count")
		end
		self.achievement = h
	end

	def achievement_pattern
		logger.error "--"*20
		logger.error achievement.inspect
		logger.error "--"*20
		errors.add(:achievement, "当前任务状态格式错误") unless achievement.all?(&@key_in_TASKRESOURCE)
	end

	def is_doing?
		return true if task.is_visible? && is_started? &&  !is_expired?
	end

	def is_started?
		return true if task.is_visible? && starts_at < task.starts_at
	end

	def is_expired?
		return true if task.is_visible? && DateTime.now < expires_at
	end

	def is_done?
		return true if task.is_visible? && done_at
	end


end
