class UserTask < ActiveRecord::Base
	
	belongs_to :task
	belongs_to :user

	serialize	:achievement, Hash
	
	def is_doing?
		return true if task.is_visible && is_started? && not is_expired?
	end

	def is_started?
		return true if starts_at < task.starts_at
	end

	def is_expired?
		return true if DateTime.now < expires_at
	end


end
