class Admin::UsersController < AdminBaseController

  def index
    @users = User.activated.paginate :page => params[:page], :per_page => 20
  end

  def destroy
    if @user.destroy
      render :update do |page|
        page.redirect_to admin_users_url
      end
    else
      render_js_error
    end
  end

  def enable
    unless @user.update_attribute(:enabled, true)
      render_js_error
    end
  end

  def disable
    unless @user.update_attribute(:enabled, false)
      render_js_error
    end
  end

  def activate
    if @user and !@user.active?
      @user.activate
      # 如果是被别人邀请的，那也没辙了，因为没有那个invite_token了，所以没法加好友
      # send email
      UserMailer.deliver_activation @user
      # create friend/comrade suggestions??
      @user.create_friend_suggestions
      @user.servers.each do |s|
        @user.create_comrade_suggestions s
      end
      redirect_to :action => 'index'
    end
  end 

  def search
    @users = User.search(params[:key]).paginate :page => params[:page], :per_page => 20
    @remote = {:update => 'users', :url => {:controller => 'admin/users', :action => 'search', :key => params[:key]}}
    render :partial => 'users', :object => @users
  end

protected

  def setup
    if ["destroy", "enable", "disable", "activate"].include? params[:action]
      @user = User.find(params[:uid])
    end
  end

end
