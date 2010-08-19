class SessionsController < ApplicationController

  def index
		render :action => 'index', :layout => 'root'
  end

  def new
    @mini_blogs = MiniBlog.category(:text).recent.limit(3).all
    render :action => (params[:at] == 'outside')? 'new_from_outside' : 'new'
  end

  def create
    self.current_user = User.authenticate(params[:email], params[:password])

    if current_user.nil?
      respond_to do |format|
        format.html {
          flash.now[:error] = "您的用户名密码不正确"
          render :action => 'index', :layout => 'root'
        }
        format.json { render :json => {:code => 2} }
      end
    elsif !current_user.active?
      reset_session
      respond_to do |format|
        format.html { redirect_to :controller => 'users', :action => 'activation_mail_sent', :email => current_user.email }
        format.json { render :json => {:code => 3} }
      end
    elsif current_user.enabled == false
      reset_session
      respond_to do |format|
        format.html { 
          flash.now[:error] = "您的帐号被删除了"
          render :action => 'index', :layout => 'root'
        }
        format.json { render :json => {:code => 4} }
      end
    else
      remember_me_in_cookie if params[:remember_me]
      respond_to do |format|
        format.html {
          flash[:notice] = "欢迎来到一起游戏网！"
          redirect_back_or_default(home_url)
        }
        format.json { render :json => {:code => 1, :login => current_user.login, :profile_id => current_user.profile.id} }
      end
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
