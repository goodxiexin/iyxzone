require 'resolv'

class RegisterController < ApplicationController

	def new_character
	  @games = Game.find(:all, :order => 'pinyin ASC')
  end

  def validates_email_uniqueness
    if User.find_by_email params[:email].downcase
      render :json => {:code => 0}
    elsif EmailDomain.valid? params[:email].downcase
      render :json => {:code => 1}
    else
      render :json => {:code => 2}
    end
  end

  def validates_login_uniqueness
    if User.find_by_login params[:login].downcase
      render :json => {:code => 0}
    else
      render :json => {:code => 1}
    end
  end

  def invite
    @sender = SignupInvitation.find_sender(params[:token]) || User.find_by_invite_fan_code(params[:token]) || User.find_by_invite_code(params[:token]) || User.find_by_qq_invite_code(params[:token]) || User.find_by_msn_invite_code(params[:token])

    if @sender.blank?
      render_not_found
    else
      @as_fan = @sender.invite_fan_code == params[:token]
			@mini_blogs = @sender.mini_blogs.category('text').limit(3).all
			@games = @sender.games[0..4]
      @people = @as_fan ? @sender.fans[0..8] : @sender.friends[0..8]
      render :action => 'invite'  
    end
  end

end
