#
# 增加用户参加过的投票的计数器
# 增加选择的那个答案的计数器
# 增加该投票的投票人数
#
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
