module User::WallMessagesHelper

  def wall_message_deleteable_by_current_user message
    wall = message.wall
    type = wall.class.name.underscore
    if type == 'Guild'
      current_user == wall.president
    elsif type == 'Event'
      current_user == wall.poster
    elsif type == 'Profile'
      current_user == wall.user
    elsif type == 'Game'
      false
    end
  end

  def wall_message_repliable_by_current_user message
    wall = message.wall
    type = wall.class.name.underscore
    if type == 'Guild'
      !@membership.nil? and (@membership.is_authorized? or @membership.is_president?)
    elsif type == 'Event'
      !@participation.nil? and @participation.is_authorized?
    elsif type == 'Profile'
      relationship == 'friend' || relationship == 'owner' || wall.user.privacy_setting.leave_wall_message == 1
    elsif type == 'Game'
      true
    end
  end

end
