class User::Profiles::TagsController < User::TagsController

protected

  def get_taggable
    Profile.find(params[:profile_id])
  rescue
    not_found
  end

  def can_create?
    @tagging = @taggable.taggings.find_by_poster_id(current_user.id)
    @user = @taggable.user
    @can_create = @user.friends.include?(current_user) && (@tagging.nil? || @tagging.created_at < 1.week.ago)
    @can_create || not_found
  end

end
