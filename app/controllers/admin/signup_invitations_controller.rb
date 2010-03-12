class Admin::SignupInvitationsController < AdminBaseController

  def new
  end

  def create
    @invitation = SignupInvitation.new(:sender_id => current_user.id, :recipient_email => params[:email])

    if @invitation.save
      render :update do |page|
        page << "$('email_invite').innerHTML = '发送成功';"
      end
    else
      render :update do |page|
        page << "$('email_invite').innerHTML = '发生错误';"
      end
    end
  end

end
