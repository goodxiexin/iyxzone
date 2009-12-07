class Rating < ActiveRecord::Base
  
	belongs_to :rateable, :polymorphic => true, :counter_cache => true
  
  belongs_to :user

	DEFAULT = 3
	MAXIMUM = 5
	MINIMUM = 1

	def validate_on_create
		if rating < Rating::MINIMUM or rating > Rating::MAXIMUM
			errors.add_to_base('越界')
		end
		if rateable.rated_by_user? user
			errors.add_to_base('已经评价国了')
		end
	end

	# rating can't be destroyed once it's created,
	# however, it can be updated
	after_save :set_average

	def set_average
		rateable.update_attribute('average_rating', rateable.ratings.average(:rating))
	end
 
end
