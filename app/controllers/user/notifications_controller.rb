class User::NotificationsController < UserBaseController

  layout 'app'

  before_filter :catch_notification, :only => [:destroy]

  def index
    @notifications = current_user.notifications
    Notification.update_all("notifications.read = 1", {:user_id => current_user.id})
  end

	def first_five
		@notifications = current_user.notifications.find(:all, :limit => 5)
    Notification.update_all("notifications.read = 1", {:id => @notifications.map(&:id)}) 
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
    Notification.destroy_all(:user_id => current_user.id)
    redirect_to notifications_url
  end

protected
        
  def catch_notification
    @notification = current_user.notifications.find(params[:id])
  rescue
    not_found
  end

end
