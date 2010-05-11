class UserTask < ActiveRecord::Base
	include Task::TaskResource
	
	belongs_to :task
	belongs_to :user

	serialize	:achievement, Hash
	serialize :goal, Hash


	validates_presence_of	:user_id
	validates_presence_of :task_id
	validate	:achievement_pattern


	def do_complete
		#TODO: give reward
		self.done_at = DateTime.now
		self.save
	end

	def is_achieved?
		goal.all? do |key,value|
			current_user.send(key) >= value
		end
	end

	def init_user_task user_id
		init_achievement_and_goal user_id
		starts_at = DataTime.now
		expires_at = min(starts_at + duration, task.expires_at)
		save
	end

	def init_achievement_and_goal user_id
		user = User.find(user_id)
		#"albums", "blogs","videos" counters are virtual attributes which are not save in DB
		achievement = {}
		goal = {}
		task.requirement.each do |key, value|
			if m = /(.*)_newly_add$/.match(key)
				achievement[m[1]] = user.send( m[1] + "_count" )
				max_item = user.send( m[1] + "_count" ) + value
				goal[m[1]] =  goal[ m[1] ] ?  max(max_item, goal[m[1]]) : max_item
			elsif m = /(.*)_morethan$/.match(key)
				achievement[m[1]] = user.send( m[1] + "_count" )
				goal[m[1]] =  goal[ m[1] ] ?  max(value, goal[ m[1]] )  : value
			else
				logger.error "unexpected requirement item: #{key}"
			end
		end
		
		self.achievement = achievement
		self.goal = goal
		save
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
