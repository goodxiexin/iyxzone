require 'app/mailer/guild_mailer'

class MembershipObserver < ActiveRecord::Observer

	#
	# here, to maintain counters, we use raw_increment rather than increment in order to avoid triggering any unnecessary callbacks
	#

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
			guild.raw_increment :invitations_count
			GuildMailer.deliver_invitation guild, membership if user.mail_setting.invite_me_to_guild?
		elsif membership.is_request?
			# request created
			guild.president.raw_increment :guild_requests_count
			guild.raw_increment :requests_count
			GuildMailer.deliver_request guild, membership if guild.president.mail_setting.request_to_attend_my_guild?
		elsif membership.is_authorized?
      guild.raw_increment field(membership.status)
      user.raw_increment :participated_guilds_count
    end
	end

  def before_update membership
    guild = membership.guild
    user = membership.user
    character = membership.character

    # 这个只能在before_udpate里做
    if membership.recently_accept_request? or membership.recently_accept_invitation?
      user.raw_increment :participated_guilds_count unless guild.has_people?(user)
    end
  end

	def after_update membership
    # update user's counter and guild counter
		guild = membership.guild
    user = membership.user
    character = membership.character

		if membership.was_invitation? and membership.is_authorized?
			guild.raw_decrement :invitations_count
      guild.raw_increment field(membership.status)
      user.raw_decrement :guild_invitations_count
      if membership.recently_accept_invitation?
			  guild.president.notifications.create(
          :category => Notification::Membership,
          :data => "#{profile_link user}接受了你的邀请: 让游戏角色 #{membership.character.name} 参加工会 #{guild_link guild}")
      end
		elsif membership.was_request? and membership.is_authorized?
			guild.raw_decrement :requests_count
      guild.raw_increment field(membership.status)
      guild.president.raw_decrement :guild_requests_count
      if membership.recently_accept_request?
			  user.notifications.create(
          :category => Notification::Membership,
          :data => "#{profile_link guild.president}同意了你的请求: 让游戏角色 #{membership.character.name} 加入工会 #{guild_link guild} ")
      end
		elsif membership.was_authorized? and membership.is_authorized?
			# promotion
			guild.raw_decrement field(membership.status_was)
      guild.raw_increment field(membership.status)
      if membership.recently_change_role?
			  user.notifications.create(
          :category => Notification::Promotion,
          :data => "你的游戏角色 #{membership.character.name} 在工会#{guild_link guild}里的职务更改为#{membership.to_s}")
        GuildMailer.deliver_promotion membership, membership.status_was if user.mail_setting.promotion_in_guild?
      end
		end

    # issue feeds if necessary
    if (membership.recently_accept_request? or membership.recently_accept_invitation?) and user.application_setting.emit_guild_feed?
      membership.deliver_feeds
    end
	end

	def after_destroy membership
		guild = membership.guild
    user = membership.user

		if membership.is_invitation?
			# invitation declined
			user.raw_decrement :guild_invitations_count
			guild.raw_decrement :invitations_count
      if membership.recently_decline_invitation?
			  guild.president.notifications.create(
          :category => Notification::Membership,
          :data => "#{profile_link user} 拒绝了你的邀请: 不让你的游戏角色 #{ membership.character.name } 参加工会#{guild_link guild}")
      end
		elsif membership.is_request?
			# request declined
			guild.president.raw_decrement :guild_requests_count
			guild.raw_decrement :requests_count
      if membership.recently_decline_request?
			  user.notifications.create(
          :category => Notification::Membership,
          :data => "#{profile_link guild.president} 拒绝了你的请求: 不让你的游戏角色 #{ membership.character.name } 加入工会#{guild_link guild}")
      end
		elsif membership.is_authorized?
			# user is evicted
			user.raw_decrement :participated_guilds_count unless guild.has_people?(user)
			guild.raw_decrement field(membership.status)
      if membership.recently_evicted?
		    user.notifications.create(
          :category => Notification::Membership,
          :data => "你的游戏角色 #{membership.character.name} 被剔除出了工会#{guild_link guild}")
      end
    end	
	end

end
