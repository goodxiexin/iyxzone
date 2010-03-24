module User::GuildsHelper

  def show_membership_info guild
    memberships = guild.memberships_for current_user
    if memberships.blank?
      if guild.is_requestable_by? current_user
        "<span id='guild_status_#{guild.id}'>没有参加</span><span id='reply_guild_#{guild.id}'>(#{link_to '请求加入', new_guild_request_url(guild, :show => 0), :rel => 'facebox'})</span>"
      else
        "没有位于该游戏服务器的游戏角色"
      end
    else
      statuses = memberships.map(&:status).uniq
      if statuses.include?(3) || statuses.include?(4) || statuses.include?(5)
        "已经加入"
      else
        "还没加入"
      end
    end 
  end

end
