class User::Games::WallMessagesController < User::WallMessagesController

protected

  def get_wall
    Game.find(params[:game_id])
  rescue
    not_found
  end

  def can_view?
    true
  end

  def can_reply?
    true
  end

  def can_delete?
    false
  end

end
