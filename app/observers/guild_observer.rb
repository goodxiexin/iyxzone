require 'app/mailer/guild_mailer'

class GuildObserver < ActiveRecord::Observer

  def before_create guild
    c = guild.president_character
    guild.game_id = c.game_id
    guild.game_server_id = c.server_id
    guild.game_area_id = c.area_id
  end

  def after_create guild
    # create album,forum and moderator_forum
    guild.create_album
    forum = guild.create_forum(:name => "工会#{guild.name}的论坛", :description => "工会#{guild.name}的论坛")
   
    # create membership
    guild.memberships.build(
      :user_id => guild.president_id, 
      :character_id => guild.character_id, 
      :status => Membership::President
    ).save_with_validation(false)
 
    # create absence rule and presence rule
    GuildRule.new(:guild_id => guild.id, :reason => "无故缺席", :outcome => -5, :rule_type => 0).save_with_validation(false)
    GuildRule.new(:guild_id => guild.id, :reason => "准时出席", :outcome => 5, :rule_type => 1).save_with_validation(false)
    
    # increment counter
    guild.president.raw_increment :guilds_count

    # issue feeds if necessary
    return if guild.president.application_setting.emit_guild_feed == 0
    recipients = [guild.president.profile, guild.game]
    recipients.concat guild.president.friends.find_all{|f| f.application_setting.recv_guild_feed == 1}
    guild.deliver_feeds :recipients => recipients
  end

  def before_update guild 
    if guild.name_changed? or guild.description_changed?
      guild.verified = 0
    end
  end
  
end
