class User::Guilds::WallMessagesController < User::WallMessagesController

protected

  def get_wall
    Guild.find(params[:guild_id])
  rescue
    not_found
  end

  def can_view?
    true
  end

  def can_reply?
    @membership = @wall.memberships.find_by_user_id(current_user.id)
    !@membership.nil? and @membership.is_authorized?
  end

  def can_delete?
    @wall.president == current_user
  end

end
