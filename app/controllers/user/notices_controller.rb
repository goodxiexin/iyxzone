class User::NoticesController < UserBaseController

	def index
    @offset = params[:offset].to_i || 0
    @limit = params[:limit].to_i || 0
    @notices = current_user.notices.offset(@offset).limit(@limit).all
    render :partial => 'notices', :object => @notices
	end

	def read
    if @notice.update_attributes(:read => 1)
		  @notices = current_user.notices.unread.limit(10).all
		  render :json => {:code => 1, :html => partial_html('notices', :object => @notices)}
    else
      render :json => {:code => 0}
    end
	end

protected

	def setup
		if ["read"].include? params[:action] 
			@notice = Notice.find(params[:id])
      require_owner @notice.user
		end
	end

end
