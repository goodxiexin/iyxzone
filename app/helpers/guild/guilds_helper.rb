module Guild::GuildsHelper

  def membership_msg(status)
    if status == 3
      "会长"
    elsif status == 4
      "长老"
    else
      "会员"
    end
  end

  def show_membership_info membership, guild
		if membership.blank?
			"<span id='guild_status_#{guild.id}'>没有参加</span><span id='reply_guild_#{guild.id}'>(#{link_to '请求加入', new_guild_request_url(guild, :show => 0), :rel => 'facebox'})</span>"
		elsif membership.status == 0
			"<span id='guild_status_#{guild.id}'>受邀请</span><span id='reply_guild_#{guild.id}'>(#{link_to '回复', edit_guild_invitation_url(guild, membership, :show => 0), :rel => 'facebox'})</span>"
		elsif membership.status == 1 or membership.status == 2
			"<span id='guild_status_#{guild.id}'>你已经请求加入工会了，请耐心等待</span>"
		else
      "<span id='guild_status_#{guild.id}'>#{membership_msg membership.status}</span>"
    end
  end

end
