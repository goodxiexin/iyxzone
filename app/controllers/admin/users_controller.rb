class Admin::UsersController < AdminBaseController

  def index
    @users = User.activated.paginate :page => params[:page], :per_page => 20
  end

  def unactivated
    @users = User.pending.paginate :page => params[:page], :per_page => 20
  end

  def destroy
    if @user.destroy
      flash[:notice] = "成功删除"
    else
      flash[:error] = "发生错误"
    end
    redirect_to :action => 'index'
  end

  def enable
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user"
    end
    redirect_to :action => 'index'
  end

  def disable
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user"
    end
    redirect_to :action => 'index'
  end

  def activate
    if @user and !@user.active?
      @user.activate
      redirect_to :action => 'index'
    end
  end 

protected

  def setup
    if ["destroy", "enable", "disable", "activate"].include? params[:action]
      @user = User.find(params[:id])
    end
  rescue
    not_found
  end

end
