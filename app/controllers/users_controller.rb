class UsersController < ApplicationController

  def new
    @user = User.new
    @games = Game.find(:all, :order => "pinyin ASC")
    render :action => 'new', :layout => 'root'
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session

    # 以防万一，万一客户端那边的email检查没有执行
    if User.find_by_email(params[:user][:email])
			render :update do |page|
				page << "$('email_info').innerHTML = '被占用';"
			end
			return
		end
      @user = User.new(params[:user])
      @user.email = params[:user][:email]
      @user.save!
      params[:characters].each do |args|
        @user.characters.create(args)
      end unless params[:characters].blank?
      params[:rating].each do |args|
        Rating.create(args.merge({:rateable_type => 'Game', :user_id => @user.id}))
      end unless params[:rating].blank?
      render :update do |page|
        page.redirect_to "/activation_mail_sent?email=#{@user.email}&show=0"
      end
      #render :update do |page|
      #  page.redirect_to '/login'
      #end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user"
    end
    redirect_to :action => 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user"
    end
    redirect_to :action => 'index'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  def activation_mail_sent
    @user = User.find_by_email(params[:email])
    if @user.nil? or @user.active?
      render :text => 'error'
    else
      render :action => 'success', :layout => 'root'
    end
  end

  def resend_activation_mail
    @user = User.find_by_email(params[:email])
    if !@user.active? and UserMailer.deliver_signup_notification @user
      render :update do |page|
        page.visual_effect 'highlight', 'account_status'
        page << "$('account_status').innerHTML = '激活邮件已经重新发送到了#{@user.email}';"
      end
    else
      render :update do |page|
        page << "error('错误');"
      end
    end
  end
  
end
