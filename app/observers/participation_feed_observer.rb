class ParticipationFeedObserver < ActiveRecord::Observer

	observe :participation

	def after_update(participation)
		return unless participation.participant.application_setting.emit_event_feed
		return if participation.was_authorized? and participation.is_authorized?
		recipients = [participation.participant.profile]
		recipients.concat participation.participant.guilds
		recipients.concat participation.participant.friends.find_all{|f| f.application_setting.recv_event_feed}
		participation.deliver_feeds :recipients => recipients
	end

end
