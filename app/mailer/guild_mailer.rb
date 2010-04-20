class GuildMailer < ActionMailer::Base

  layout 'mail'

  def name_change	guild, member
    setup_email	member
    subject			"17Gaming.com(一起游戏网) - 工会#{guild.name_was}改名字了"
		body				:user => member, :url => "#{SITE_URL}/guilds/#{guild.id}"
  end

	def invitation guild, invitation
		setup_email invitation.user
		subject		 "17Gaming.com(一起游戏网) - #{guild.president.login}邀请你的游戏角色#{invitation.character.name}加入工会#{guild.name}"
		body			 :guild => guild, :user => invitation.user, :character => invitation.character, :url => "#{SITE_URL}/invitations?type=2"
	end

	def request guild, request
		setup_email guild.president
		subject		 "17Gaming.com(一起游戏网) - #{request.user.login}请求让游戏角色#{request.character.name}加入工会#{guild.name}"
		body			 :guild => guild, :user => request.user, :character => request.character, :url => "#{SITE_URL}/requests?type=2"
	end

	def promotion membership, old_role
		setup_email membership.user
		subject		 "17Gaming.com(一起游戏网) - 您在公会中的职位变为#{membership.to_s}"
		body			 :user => membership.user, :membership => membership, :old_role => old_role, :url => "#{SITE_URL}/guilds/#{membership.guild_id}"
	end

  def guild_cancel guild, member
    setup_email member
    subject     "17Gaming.com(一起游戏网) - 工会'#{guild.name}'取消了"
    body        :guild => guild, :user => member, :president => guild.president
  end

  def reply_post post, recipient
    setup_email recipient
    subject     "17Gaming.com(一起游戏网) - 工会'#{post.forum.guild.name}'取消了"
    body        :post => post, :user => recipient, :url => "#{SITE_URL}/forums/#{post.forum_id}/topics/#{post.topic_id}/posts?post_id=#{post.id}"
  end

protected

  def setup_email member
		recipients	member.email
		from				SITE_MAIL
		sent_on			Time.now
  end

end
