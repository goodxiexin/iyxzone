class User::Profiles::WallMessagesController < User::WallMessagesController

protected

  def get_wall
    Profile.find(params[:profile_id])
  rescue
    not_found
  end

  def can_view?
    current_user == @wall.user || 
    @wall.user.friends.include?(current_user) || 
    @wall.user.privacy_setting.wall == 1 || 
    (@wall.user.privacy_setting.wall == 2 and @wall.user.has_same_game_with(current_user)) || 
    not_found 
  end

  def can_reply?
    current_user == @wall.user || @wall.user.friends.include?(current_user) 
  end

  def can_delete?
    @wall.user == current_user
  end

end
