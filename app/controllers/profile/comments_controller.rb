class Profile::CommentsController < CommentsController

  layout 'app'

  before_filter :owner_required, :only => [:destroy]

protected

  def catch_commentable
    @profile = Profile.find(params[:profile_id])
    @user = @profile.user
    @commentable = @profile
  rescue
    not_found
  end

  def owner_required
    @user == current_user || not_found
  end


end
