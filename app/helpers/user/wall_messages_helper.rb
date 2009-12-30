module User::WallMessagesHelper

  def wall_message_deletable_by_current_user message
    wall = message.commentable
    case wall.class.name.underscore
      when 'guild'    then  current_user == wall.president
      when 'event'    then  current_user == wall.poster
      when 'profile'  then  current_user == wall.user
      when 'game'     then  false # 谁可以删除呢？
    end
  end

end
