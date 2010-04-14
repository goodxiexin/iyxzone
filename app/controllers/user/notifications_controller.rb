class User::NotificationsController < UserBaseController

  layout 'app'

  def index
    @notifications = current_user.notifications
    Notification.read_all current_user
  end

	def first_five
		@notifications = current_user.notifications.unread.find(:all, :limit => 5)
		Notification.read @notifications, current_user
    render :action => 'first_five', :layout => false
	end

  def destroy
    if @notification.destroy
      render :update do |page|
			  page << "$('notification_#{@notification.id}').remove();"
		  end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def destroy_all
    Notification.delete_all(:user_id => current_user.id)
    current_user.update_attribute(:notifications_count, 0)
    current_user.update_attribute(:unread_notifications_count, 0)
    flash[:notice] = '删除成功'
    render :update do |page|
      page.redirect_to notifications_url
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
