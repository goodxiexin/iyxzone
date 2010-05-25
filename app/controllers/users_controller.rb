class UsersController < ApplicationController

  def new
    @user = User.new
    render :action => 'new', :layout => 'root'
  end

  def create
    cookies.delete :auth_token
    @email = params[:user].delete(:email)
    @user = User.new(params[:user])
    @user.email = @email.downcase
    @user.invitee_code = params[:invite_token] # 谁邀请来的

    if @user.save && @user.profile.update_attributes(params[:profile]) # TODO
      redirect_js "/activation_mail_sent?email=#{@email}"
    else
      render_js_error
    end
	end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "激活成功"
    else
      flash[:error] = "不正确的激活码"
    end
    redirect_back_or_default('/login')
  end

  def activation_mail_sent
    @user = User.find_by_email(params[:email])
    
    if @user.nil? or @user.active?
      render_not_found
    else
      render :action => 'success', :layout => 'root'
    end
  end

  def resend_activation_mail
    @user = User.find_by_email(params[:email])
    
    if !@user.active? and UserMailer.deliver_signup_notification(@user)
      render :update do |page|
        page.visual_effect 'highlight', 'account_status'
        page << "$('account_status').innerHTML = '激活邮件已经重新发送到了#{@user.email}';"
      end
    else
      render_js_error
    end
  end

end
