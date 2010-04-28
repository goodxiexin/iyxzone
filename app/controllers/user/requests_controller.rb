class User::RequestsController < UserBaseController

	layout 'app'

	def index
		@requests = []
    if params[:type].blank?
      @requests.concat current_user.event_requests.all(:include => [:event, {:participant => :profile}])
      @requests.concat current_user.friend_requests.all(:include => [:poll, {:user => :profile}])
      @requests.concat current_user.guild_requests.all(:include => [:guild, {:user => :profile}])
      @requests = @requests.paginate :page => params[:page], :per_page => 10
    elsif params[:type].to_i == 1
      @requests = current_user.friend_requests.paginate :page => params[:page], :per_page => 10, :include => [:user, {:participant => :profile}]
    elsif params[:type].to_i == 2
      @requests = current_user.event_requests.paginate :page => params[:page], :per_page => 10, :include => [:event, {:user => :profile}]
    elsif params[:type].to_i == 3
      @requests = current_user.guild_requests.paginate :page => params[:page], :per_page => 10, :include => [:guild, {:user => :profile}]
    end
	end

end
