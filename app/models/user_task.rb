class UserTask < ActiveRecord::Base
	include Task::TaskResource
	
	belongs_to :task
	belongs_to :user

	serialize	:achievement, Hash
	serialize :goal, Hash


	validates_presence_of	:user_id
	validates_presence_of :task_id
	validate	:goal_pattern

	def show_notification
		notification = []
		notification << "任务已过期" if self.is_expired?
		notification
	end

	def self.get_all_user_task user_id
		UserTask.all(:conditions => {:user_id => user_id})
	end

	def do_complete
		#TODO: give reward
		self.done_at = DateTime.now
		self.save
	end

	def is_achieved?
		goal.all? do |key,value|
			logger.error key+"_count"
			self.user.send(key+"_count") >= value
		end
	end

	def init_user_task user_id
		init_achievement_and_goal user_id
		self.starts_at = DateTime.now
		self.expires_at = (self.starts_at.since(task.duration) > task.expires_at) ? task.expires_at : self.starts_at.since(task.duration)
	end

	def init_achievement_and_goal user_id
		user = User.find(user_id)
		#"albums", "blogs","videos" counters are virtual attributes which are not save in DB
		#achievement = {}
		goal = {}
		task.requirement.each do |key, value|
			if m = /(.*)_add$/.match(key)
				#achievement[m[1]] = user.send( m[1] + "_count" )
				goal_of_add = user.send( m[1] + "_count" ) + value
				goal[m[1]] =  goal[ m[1] ] ?  goal_of_add > goal[ m[1]] ? goal_of_add: goal[m[1]] : goal_of_add
			elsif m = /(.*)_morethan$/.match(key)
				#achievement[m[1]] = user.send( m[1] + "_count" )
				goal[m[1]] =  goal[ m[1] ] ?  value > goal[ m[1]] ? value : goal[m[1]]  : value
			else
				logger.error "unexpected requirement item: #{key}"
			end
		end
		
		#self.achievement = achievement
		self.goal = goal
	end
	#def achievement_pattern
		#errors.add(:achievement, "当前任务状态格式错误") unless achievement.all?(&@key_in_TASKRESOURCE)
	#end
	def goal_pattern
		errors.add(:goal, "当前任务状态格式错误") unless goal.all?(&@@key_in_TASKRESOURCE)
	end

	def is_doing?
		return true if task.is_visible? && is_started? &&  !is_expired?
	end

	def is_started?
		return true if task.is_visible? && starts_at < task.starts_at
	end

	def is_expired?
		return true if task.is_visible? && DateTime.now > expires_at
	end

	def is_done?
		return true if task.is_visible? && done_at
	end
	
#TODO: if redo_able?
	def redo_able?
		false
	end


end
