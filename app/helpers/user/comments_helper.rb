module User::CommentsHelper

  def comment_deletable_by_current_user comment
    commentable = comment.commentable
    case commentable.class.name.underscore
      when 'blog'     then  (current_user == comment.poster || current_user == commentable.poster)
      when 'status'   then  (current_user == comment.poster || current_user == commentable.poster)
      when 'video'    then  (current_user == comment.poster || current_user == commentable.poster)
      when 'poll'     then  (current_user == comment.poster || current_user == commentable.poster)
      when 'event'    then  (current_user == commentable.poster)
      when 'guild'    then  (current_user == commentable.president)
      when 'personal_album' then (current_user == commentable.poster)
      when 'personal_photo' then (current_user == commentable.poster)
      when 'avatar_album'   then (current_user == commentable.poster)
      when 'avatar'         then (current_user == commentable.poster)
      when 'event_album'    then (current_user == commentable.poster)
      when 'event_photo'    then (current_user == commentable.poster)
      when 'guild_album'    then (current_user == commentable.poster || commentable.guild.veterans.include?(current_user))
      when 'guild_photo'    then (current_user == commentable.poster || commentable.guild.veterans.include?(current_user))
    end  
  end

end
