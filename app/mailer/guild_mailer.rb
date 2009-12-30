class GuildMailer < ActionMailer::Base

  def name_change	guild, member
    setup_email	member
    subject			"Dayday3 - 工会#{guild.name_was}改名字了"
		body				:user => member, :url => "#{SITE_URL}/guilds/#{guild.id}"
  end

	def invitation guild, member
		setup_email member
		subject		 "Dayday3 - #{guild.president.login}邀请你加入工会#{guild.name}"
		body			 :user => member, :url => "#{SITE_URL}/invitations?type=2"
	end

	def request guild, member
		setup_email member
		subject		 "Dayday3 - #{member.login}请求加入工会#{guild.name}"
		body			 :user => member, :url => "#{SITE_URL}/requests?type=2"
	end

	def promotion guild, member, new_role, old_role
		setup_email membership.user
	end

protected

  def setup_email member
		recipients	member.email
		from				SITE_MAIL
		sent_on			Time.now
  end

end
