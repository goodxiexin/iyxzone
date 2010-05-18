class SessionsController < ApplicationController

  def new
    if params[:at] == 'outside'
      render :action => 'new_from_outside'
    else
      render :action => 'new'
    end
  end

  def create
    @user = User.find_by_email(params[:email])
    if !@user.nil? and !@user.active?
      redirect_to :controller => 'users', :action => 'activation_mail_sent', :email => @user.email, :show => 1
      return
    end
    self.current_user = User.authenticate(params[:email], params[:password])
    if current_user == nil
      flash.now[:error] = "用户名密码不正确"
      if params[:at] == 'outside'
        render :action => 'new_from_outside'
      else
        render :action => 'new'
      end
    elsif current_user.enabled == false
      flash.now[:error] = "你的帐号被删除了"
      if params[:at] == 'outside'
        render :action => 'new_from_outside'
      else
        render :action => 'new'
      end
    else
      if params[:remember_me] == "1"
        current_user.remember_me
      else
        current_user.remember_me_for SESSION_DURATION
      end
      flash[:notice] = "欢迎来到一起游戏网！"
      redirect_back_or_default(home_url)
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    #cookies.delete :auth_token
    reset_session
    flash[:notice] = "成功登出"
    redirect_to login_url
  end

end
