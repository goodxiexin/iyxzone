class UsersController < ApplicationController

  before_filter :logout_required
  #before_filter :allow_only_admin_invitation

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

    @email = params[:user].delete(:email)
    @user = User.new(params[:user])
    @user.email = @email.downcase
    if @user.save
      # send email
      UserMailer.deliver_signup_notification @user, params[:invite_token]
      # create characters
      @user.profile.update_attributes(params[:profile]) # TODO
      render :update do |page|
        page.redirect_to "/activation_mail_sent?email=#{@email}&show=0&invite_token=#{params[:invite_token]}"
      end
    else
      render :update do |page|
        page << "error('发生错误，稍后再试');"
      end
    end
	end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      # create friend
      unless params[:invite_token].blank?
        parse_invite_token params[:invite_token]
        unless @sender.blank?
          current_user.friendships.create(:friend_id => @sender.id)
          @sender.friendships.create(:friend_id => current_user.id)
          current_user.invite_method = @method
          current_user.save
        end
      end
      # send email
      UserMailer.deliver_activation current_user
      flash[:notice] = "激活成功"
    end
    redirect_back_or_default('/login')
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
    if !@user.active? and UserMailer.deliver_signup_notification @user, params[:invite_token]
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

protected

  def parse_invite_token token
    invitation = SignupInvitation.find_by_token token
    if invitation.blank?
      @sender = User.find_by_invite_code(token) || User.find_by_qq_invite_code(token) || User.find_by_msn_invite_code(token)
    else
      @sender = invitation.sender
    end
    unless @sender.blank?
      if @sender.invite_code == token
        @method = 'magic'
      elsif @sender.qq_invite_code == token
        @method = 'qq'
      elsif @sender.msn_invite_code == token
        @method = 'msn'
      else
        @method = 'email'
      end
    end
  end

  def allow_only_admin_invitation
    parse_invite_token params[:invite_token]
    (!@sender.nil? and @sender.has_role?('admin') and @method == 'email') || render(:action => 'not_open')
  end
    
end
