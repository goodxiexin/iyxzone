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

    @user = User.new(params[:user])
    @user.email = params[:user][:email]
    if @user.save
      # create characters
      @user.profile.update_attributes(params[:profile]) # TODO
      if params[:token]
        render :update do |page|
          page.redirect_to "/activation_mail_sent?email=#{@user.email}&show=0&token=#{params[:token]}"
        end
      end
    else
      render :update do |page|
        page << "error('#{@user.errors.on_base}');"
      end
    end
	end

  def activate
      self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
      if logged_in? && !current_user.active?
        current_user.activate
        # create friend
        unless params[:token].blank?
          @invitation = SignupInvitation.find_by_token(params[:token])
          if @invitation.blank?
            @sender = User.find_by_invite_code(params[:token]) || User.find_by_qq_invite_code(params[:token]) || User.find_by_msn_invite_code(params[:code])
          else
            @sender = @invitation.sender
          end
          unless @sender.blank?
            current_user.friendships.create(:friend_id => @sender.id)
            @sender.friendships.create(:friend_id => current_user.id)
            # 记录用户是通过怎样的邀请加入的
            if @sender.invite_code == params[:token]
              current_user.invite_method = 'magic'
            elsif @sender.qq_invite_code == params[:token]
              current_user.invite_method = 'qq'
            elsif @sender.msn_invite.code == params[:token]
              current_user.invite_method = 'msn'
            else
              current_user.invite_method = 'email'
            end
            current_user.save
          end
        end
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
