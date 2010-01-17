class User::Profiles::TagsController < User::TagsController

protected

  def get_taggable
    Profile.find(params[:profile_id])
  rescue
    not_found
  end

end
