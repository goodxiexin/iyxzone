class User::Events::WallMessagesController < User::WallMessagesController

protected

  def get_wall
    Event.find(params[:event_id])
  rescue
    not_found
  end

  def can_view?
    true
  end

  def can_reply?
    @participation = @wall.participations.find_by_participant_id(current_user.id)
    !@participation.nil? and @participation.is_authorized?
  end

  def can_delete?
    @wall.poster == current_user
  end

end
