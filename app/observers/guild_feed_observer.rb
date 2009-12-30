class GuildFeedObserver < ActiveRecord::Observer

	observe :guild

	def after_create guild
		return unless guild.president.application_setting.emit_guild_feed
		recipients = [guild.president.profile]
		recipients.concat guild.president.friends.find_all{|f| f.application_setting.recv_guild_feed}
		guild.deliver_feeds :recipients => recipients
	end

end
