class User::ProfileViewingsController < ApplicationController

  before_filter :login_required

  def index
    @viewings = current_user.profile.viewings.paginate :page => params[:page], :per_page => 1
    @remote = {:update => 'visitor_records', :url => {:action => 'index'}}
  end

end
