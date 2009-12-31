class User::Games::TagsController < User::TagsController

protected

  def get_taggable
    Game.find(params[:game_id])
  rescue
    not_found
  end

  def can_create?
    @tagging = @taggable.taggings.find_by_poster_id(current_user.id)
    @tagging.nil? || (@tagging.created_at < 1.week.ago) || not_found
  end

end
