class SessionsController < ApplicationController

  def index
		render :action => 'index', :layout => 'root'
  end

  def new
    @mini_blogs = MiniBlog.category(:text).limit(3).all
    render :action => (params[:at] == 'outside')? 'new_from_outside' : 'new'
  end

  def create
    self.current_user = User.authenticate(params[:email], params[:password])

    if current_user.nil?
      flash.now[:error] = "您的用户名或者密码输入不正确"
      render :action => (params[:at] == 'outside')? 'new_from_outside' : 'index', :layout => (params[:at] == 'outside')? '':'root'
    elsif !current_user.active?
      reset_session
      redirect_to :controller => 'users', :action => 'activation_mail_sent', :email => current_user.email
    elsif current_user.enabled == false
      flash.now[:error] = "你的帐号被删除了"
      render :action => (params[:at] == 'outside')? 'new_from_outside' : 'index', :layout => (params[:at] == 'outside')? '':'root'
    else
      remember_me_in_cookie if params[:remember_me]
      flash[:notice] = "欢迎来到一起游戏网！"
      redirect_back_or_default(home_url)
    end
  end

  def destroy
    #self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "成功登出"
    redirect_to login_url
  end

end
