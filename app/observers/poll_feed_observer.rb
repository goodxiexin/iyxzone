class PollFeedObserver < ActiveRecord::Observer

	observe :poll

  def after_create(poll)
		return unless poll.poster.application_setting.emit_poll_feed
		recipients = [poll.poster.profile]
		recipients.concat poll.poster.guilds
		recipients.concat poll.poster.friends.find_all{|f| f.application_setting.recv_poll_feed}
		poll.deliver_feeds :recipients => recipients
	end

end
