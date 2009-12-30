class VoteFeedObserver < ActiveRecord::Observer

	observe :vote

	def after_create vote
		return unless vote.voter.application_setting.emit_poll_feed
		recipients = [vote.voter.profile]
		recipients.concat vote.voter.guilds
		recipients.concat vote.voter.friends.find_all{|f| f.application_setting.recv_poll_feed}
		vote.deliver_feeds :recipients => recipients
	end

end
