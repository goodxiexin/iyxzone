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
		gj = GoalJudge.new(self, self.user)
    gj.goal_satisfy?
	end
  



	def init_achievement_and_goal user_id
		user = User.find(user_id)
		#"albums", "blogs","videos" counters are virtual attributes which are not save in DB
		#achievement = {}
		goal = {}
	
	end

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
