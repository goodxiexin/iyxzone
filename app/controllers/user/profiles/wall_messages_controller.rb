class User::Profiles::WallMessagesController < User::WallMessagesController

protected

  def get_wall
    Profile.find(params[:profile_id])
  rescue
    not_found
  end

  def can_view?
    @user = @wall.user
    is_owner? || is_friend? || @user.privacy_setting.wall == 1 || (@user.privacy_setting.wall == 2 and is_same_game?) || not_found 
  end

end
