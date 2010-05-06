
class Task < ActiveRecord::Base
	INVISIBLE = 1
	REGULAR = 2
	EVERYDAY = 3
	
	serialize :prerequisite, Hash
	serialize	:requirement,	Hash
	serialize	:description, Hash
	serialize	:reward, Hash

	has_many :user_tasks

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
