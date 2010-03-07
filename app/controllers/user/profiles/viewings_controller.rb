class User::Profiles::ViewingsController < UserBaseController

  def index
    @profile = Profile.find(params[:profile_id])
    @viewings = @profile.viewings.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'visitor_records', :url => {:action => 'index'}}
  end

end
