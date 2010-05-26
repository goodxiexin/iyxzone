class PasswordsController < ApplicationController

  layout 'root'

  def new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user.nil?
      flash.now[:error] = "该邮箱没有注册我们网站"
      render :action => 'new'
    elsif !@user.active?
      redirect_to activation_mail_sent_url(:email => @user.email)
    else
      @user.forgot_password
      flash[:notice] = "一封重置密码的邮件已经发到你的邮箱里了"
      redirect_to login_path
    end
  end

  def edit
    @user = params[:password_reset_code].blank? ? nil : User.find_by_password_reset_code(params[:password_reset_code])
    
    if @user.blank?
      render_not_found
    else
      render :action => 'edit'
    end   
  end

  def update
    @user = params[:password_reset_code].nil? ? nil : User.find_by_password_reset_code(params[:password_reset_code])

    if @user.blank?
      flash.now[:error] = "非法的重置码"
      render :action => 'edit', :password_reset_code => params[:password_reset_code]
    else
      if @user.reset_password params[:password], params[:password_confirmation]
        flash[:notice] = "密码已经重置"
        redirect_to '/login'
      else
        flash.now[:error] = "发生错误, 请重新输入密码"
        render :action => 'edit', :password_reset_code => params[:password_reset_code]
      end
    end
  end

end
