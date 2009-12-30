require 'app/mailer/guild_mailer'

class GuildObserver < ActiveRecord::Observer

  def after_create(guild)
    guild.create_album(:title => "工会#{guild.name}的相册", :privilege => 1, :game_id => guild.game_id, :poster_id => guild.president_id)
    guild.memberships.create(:user_id => guild.president_id, :status => Membership::President)
    forum = guild.create_forum(:name => "工会#{guild.name}的论坛", :description => "工会#{guild.name}的论坛")
    ModeratorForum.create(:moderator_id => guild.president_id, :forum_id => forum.id)
  end

  def after_update(guild)
    if guild.name_changed?
      guild.members.each do |member|
        if member.mail_setting.change_name_of_guild and member != guild.president
          GuildMailer.deliver_name_change(guild, member)
        end
      end
    end 
  end

	# a guild can never be destroyed once it's created

end
