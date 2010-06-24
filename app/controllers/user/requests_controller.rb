class User::RequestsController < UserBaseController

	layout 'app'

  PER_PAGE = 10

	def index
		@requests = []
    if params[:type].blank?
      @requests.concat current_user.event_requests.prefetch([:event, {:participant => :profile}])
      @requests.concat current_user.friend_requests.prefetch([{:user => :profile}])
      @requests.concat current_user.guild_requests.prefetch([:guild, {:user => :profile}])
      @requests = @requests.sort {|a,b| b.created_at <=> a.created_at}.paginate :page => params[:page], :per_page => PER_PAGE
    elsif params[:type].to_i == 1
      @requests = current_user.friend_requests.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:user => :profile}]
    elsif params[:type].to_i == 2
      @requests = current_user.event_requests.paginate :page => params[:page], :per_page => PER_PAGE, :include => [:event, {:participant => :profile}]
    elsif params[:type].to_i == 3
      @requests = current_user.guild_requests.paginate :page => params[:page], :per_page => PER_PAGE, :include => [:guild, {:user => :profile}]
    end
	end

end
