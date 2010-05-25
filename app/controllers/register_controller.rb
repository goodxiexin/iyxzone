class RegisterController < ApplicationController

	def new_character
	  @games = Game.find(:all, :order => 'pinyin ASC')
  end

  def validates_email_uniqueness
    if User.find_by_email(params[:email].downcase)
      render :text => 'no'
    else
      render :text => 'yes'
    end
  end

  def invite
    @sender = SignupInvitation.find_sender(params[:token]) || User.find_by_invite_code(params[:token]) || User.find_by_qq_invite_code(params[:token]) || User.find_by_msn_invite_code(params[:token])

    if @sender.blank?
      render_not_found
    else
      @friends = @sender.friends[0..11]
      render :action => 'invite'  
    end
  end

end
