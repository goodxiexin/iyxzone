#
# 增加用户参加过的投票的计数器
# 增加选择的那个答案的计数器
# 增加该投票的投票人数
#
class VoteObserver < ActiveRecord::Observer

  def before_create vote
    vote.answer_ids = vote.answer_ids.uniq
  end

	def after_create vote
    voter = vote.voter
    poll = vote.poll

    # increment voter's counter, answer's counter and poll's counter
		voter.raw_increment(:participated_polls_count) if poll.poster != voter
		vote.answers.each do |answer|
			answer.raw_increment :votes_count
		end
		poll.raw_increment :votes_count, vote.answers.count 
	  poll.raw_increment :voters_count

    # issue feeds if necessary
    if voter.application_setting.emit_poll_feed?
      vote.deliver_feeds
    end
  end

  # 这个可能在某个用户被删除后触发
  def after_destroy vote
    vote.answers.each do |answer|
      answer.raw_decrement :votes_count
    end
    vote.poll.raw_decrement :votes_count, vote.answers.count
    vote.poll.raw_decrement :voters_count 
  end

end
