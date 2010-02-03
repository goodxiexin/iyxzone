class Rating < ActiveRecord::Base
  
	belongs_to :rateable, :polymorphic => true
  
  belongs_to :user

	DEFAULT = 3
	MAXIMUM = 5
	MINIMUM = 1

  def validate
    if rating < Rating::MINIMUM or rating > Rating::MAXIMUM
      errors.add_to_base('越界')
      return
    end
  end

	def validate_on_create
		if rateable.rated_by_user? user
			errors.add_to_base('已经打分过了')
      return
		elsif !rateable.is_rateable_by? user
      errors.add_to_base('没有打分的权力')
      return
    end
	end

end
