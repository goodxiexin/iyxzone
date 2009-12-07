class MembershipFeedObserver < ActiveRecord::Observer

	observe :membership

	def after_update membership
		return unless membership.user.application_setting.emit_guild_feed
		return unless [3,4,5].include? membership.status
		recipients = [membership.user.profile]
		recipients.concat membership.user.friends.find_all{|f| f.application_setting.recv_guild_feed}
		membership.deliver_feeds :recipients => recipients
	end

end
