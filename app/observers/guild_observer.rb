require 'app/mailer/guild_mailer'

class GuildObserver < ActiveRecord::Observer

  def after_create guild
    # create album, membership, forum and moderator_forum
    guild.create_album
    guild.memberships.create(:user_id => guild.president_id, :status => Membership::President)
    forum = guild.create_forum(:name => "工会#{guild.name}的论坛", :description => "工会#{guild.name}的论坛")
    ModeratorForum.create(:moderator_id => guild.president_id, :forum_id => forum.id)
  
    # increment counter
    guild.president.raw_increment :guilds_count

    # issue feeds if necessary
    return unless guild.president.application_setting.emit_guild_feed
    recipients = [guild.president.profile]
    recipients.concat guild.president.friends.find_all{|f| f.application_setting.recv_guild_feed}
    guild.deliver_feeds :recipients => recipients
  end

  def after_update(guild)
    if guild.name_changed?
      guild.veterans_and_members.each do |member|
        if member.mail_setting.change_name_of_guild and member != guild.president
          GuildMailer.deliver_name_change(guild, member)
        end
      end
    end 
  end

	# a guild can never be destroyed once it's created

end
