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

    if @user.save
      @user.profile.update_attributes(params[:profile])
      logger.error @user.reload.characters_count
      if @user.reload.characters_count == 0
        @user.destroy
        render :json => {:code => 2}
      else
        render :json => {:code => 1, :email => @email}
      end
    else
      if !@user.errors.on(:email).blank?
        render :json => {:code => 3}
      elsif !@user.errors.on(:login).blank?
        render :json => {:code => 4}
      end
    end
	end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    
    if logged_in? && !current_user.active?
      current_user.activate
      render :action => 'activated', :layout => 'root'
    else
      flash[:error] = "不正确的激活码"
			redirect_back_or_default('/login')
    end
  end

  def more_games
    @games = Game.sexy.limit(12)
    render :action => 'more_games', :layout => 'root'
	end

  def more_friends
		@friend_suggestions = current_user.friend_suggestions.limit(30)
		@idols = User.match(:is_idol => true).order("fans_count DESC")
		@guilds = Guild.hot.nonblocked.match(user_game_conds).limit(5)
    render :action => 'more_friends', :layout => 'root'
	end

  def upload_avatar
    render :action => 'upload_avatar', :layout => 'root'
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
