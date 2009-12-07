class VoteCounterObserver < ActiveRecord::Observer

	observe :vote

	def after_create(vote)
		vote.voter.raw_increment(:participated_polls_count) if vote.poll.poster != vote.voter
		vote.answers.each do |answer|
			answer.raw_increment :votes_count
		end
		vote.poll.raw_increment :votes_count, vote.answers.count 
	end

end
