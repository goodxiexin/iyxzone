class User::NotificationsController < UserBaseController

  layout 'app'

  def index
    @notifications = current_user.notifications
    Notification.read_all current_user
  end

	def first_five
		@notifications = current_user.notifications.unread.limit(5).all
		Notification.read @notifications, current_user
    render :action => 'first_five', :layout => false
	end

  def destroy
    if @notification.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy_all
    if Notification.delete_all(:user_id => current_user.id) && current_user.update_attributes(:notifications_count => 0, :unread_notifications_count => 0)
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected
        
  def setup
    if ["destroy"].include? params[:action]
      @notification = Notification.find(params[:id])
      require_owner @notification.user
    end
  end

end
