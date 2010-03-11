class GuildMailer < ActionMailer::Base

  def name_change	guild, member
    setup_email	member
    subject			"17Gaming.com(一起游戏网) - 工会#{guild.name_was}改名字了"
		body				:user => member, :url => "#{SITE_URL}/guilds/#{guild.id}"
  end

	def invitation guild, invitation
		setup_email invitation.user
		subject		 "17Gaming.com(一起游戏网) - #{guild.president.login}邀请你的游戏角色#{invitation.character.name}加入工会#{guild.name}"
		body			 :guild => guild, :user => invitation.user, :url => "#{SITE_URL}/invitations?type=2"
	end

	def request guild, request
		setup_email guild.president
		subject		 "17Gaming.com(一起游戏网) - #{request.user.login}请求让游戏角色#{request.character.name}加入工会#{guild.name}"
		body			 :guild => guild, :user => request.user, :url => "#{SITE_URL}/requests?type=2"
	end

	def promotion membership, old_role
		setup_email membership.user
		subject		 "17Gaming.com(一起游戏网) - 您在公会中的职位变为#{membership.to_s}"
		body			 :membership => membership, :old_role => old_role, :url => "#{SITE_URL}/guilds/#{guild.id}"
	end

protected

  def setup_email member
		recipients	member.email
		from				SITE_MAIL
		sent_on			Time.now
  end

end
