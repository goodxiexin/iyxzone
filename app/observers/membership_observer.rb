require 'app/mailer/guild_mailer'

class MembershipObserver < ActiveRecord::Observer

	#
	# here, to maintain counters, we use raw_increment rather than increment in order to avoid triggering any unnecessary callbacks
	#

	def role status
		if status == Membership::Veteran
			"长老"
		elsif status == Membership::Member
			"普通会员"
		end
	end

	def field status
		if status == Membership::President
			"presidents_count"
		elsif status == Membership::Veteran
			"veterans_count"
		elsif status == Membership::Member
			"members_count"
		end
	end

	def after_create membership
		guild = membership.guild
		user = membership.user
		if membership.is_invitation?
			# invitation created
			user.raw_increment :guild_invitations_count
			guild.raw_increment :invitees_count
			GuildMailer.deliver_invitation guild, user if user.mail_setting.invite_me_to_guild
		elsif membership.is_request?
			# request created
			guild.president.raw_increment :guild_requests_count
			guild.raw_increment :requestors_count
			GuildMailer.deliver_request guild, user if guild.president.mail_setting.request_to_attend_my_guild
		elsif membership.is_authorized?
      guild.raw_increment field(membership.status)
      user.raw_increment :participated_guilds_count
    end
	end

	def after_update membership
    # update user's counter and guild counter
		guild = membership.guild
    user = membership.user
		if membership.was_invitation? and membership.is_authorized?
			user.raw_decrement :guild_invitations_count
			user.raw_increment :participated_guilds_count
			guild.raw_decrement :invitees_count
      guild.raw_increment field(membership.status)
			membership.notifications.create(:user_id => guild.president_id, :data => "#{profile_link user}接受了你的邀请，参加工会#{guild_link guild}")
		elsif membership.was_request? and membership.is_authorized?
			guild.president.raw_decrement :guild_requests_count
			user.raw_increment :participated_guilds_count
			guild.raw_decrement :requestors_count
      guild.raw_increment field(membership.status)
			membership.notifications.create(:user_id => user.id, :data => "#{profile_link guild.president}同意你加入工会#{guild_link guild}的请求")
		elsif membership.was_authorized? and membership.is_authorized?
			# nomination
			guild.raw_decrement field(membership.status_was)
      guild.raw_increment field(membership.status)
			membership.notifications.create(:user_id => user.id, :data => "你在工会#{guild_link guild}里的职务更改为#{role membership.status}")
		end

    # issue feeds if necessary
    return unless user.application_setting.emit_guild_feed
    return if membership.was_authorized? and membership.is_authorized?
    recipients = [user.profile]
    recipients.concat user.friends.find_all{|f| f.application_setting.recv_guild_feed}
    membership.deliver_feeds :recipients => recipients
	end

	def after_destroy membership
		guild = membership.guild
    user = membership.user
		if membership.is_invitation?
			# invitation declined
			user.raw_decrement :guild_invitations_count
			guild.raw_decrement :invitees_count
			guild.president.notifications.create(:data => "#{profile_link user}拒绝了你的邀请，参加工会#{guild_link guild}")
		elsif membership.is_request?
			# request declined
			guild.president.raw_decrement :guild_requests_count
			guild.raw_decrement :requestors_count
			user.notifications.create(:data => "#{profile_link guild.president}决绝你加入工会#{guild_link guild}的请求")
		elsif membership.is_authorized?
			# you are evicted by president
			user.raw_decrement :participated_guilds_count
			guild.raw_decrement field(membership.status)
		  user.notifications.create(:data => "你被剔除出了工会#{guild_link guild}")
    end	
	end

end
