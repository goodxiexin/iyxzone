class EventFeedObserver < ActiveRecord::Observer

	observe :event

	def after_create(event)
		return unless event.poster.application_setting.emit_event_feed
		recipients = [event.poster.profile]
		recipients.concat event.poster.guilds
		recipients.concat event.poster.friends.find_all{|f| f.application_setting.recv_event_feed}
		event.deliver_feeds :recipients => recipients
	end

end
