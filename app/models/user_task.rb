class UserTask < ActiveRecord::Base
	include Task::TaskResource
	
	belongs_to :task
	belongs_to :user

	serialize	:achievement, Hash


	validates_presence_of	:user_id
	validates_presence_of :task_id
	validate	:achievement_pattern

	def achievement_pattern
		errors.add(:achievement, "当前任务状态格式错误") unless achievement.all?(&:key_in_TASKRESOURCE)
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
