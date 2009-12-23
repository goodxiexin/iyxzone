class Vote < ActiveRecord::Base

	serialize :answer_ids, Array

  belongs_to :voter, :class_name => 'User'

  belongs_to :poll, :counter_cache => :voters_count

	acts_as_resource_feeds

	def answers
		PollAnswer.find(answer_ids)
	end

  def validate_on_create
    errors.add_to_base('你已经投过票了') if poll.voters.include?(voter)
  end

end
