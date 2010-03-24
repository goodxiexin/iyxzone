class User::SignupInvitationsController < UserBaseController

  layout 'app'

  def index
  end

  def add_friend
    session[:email_authentication] = {:type => params[:type], :user_name => params[:user_name], :password => params[:password]}
  end

  def invite_contact
    @type = session[:email_authentication][:type]
    @user_name = session[:email_authentication][:user_name]
  end

  def create
    @invitation = SignupInvitation.new(:sender_id => current_user.id, :recipient_email => params[:email])
    
    if @invitation.save
      render :update do |page|
        page << "Iyxzone.enableButton($('email_invitation_btn'),'发送邀请');"
        page << "$('email_invite').innerHTML = '发送成功';"
      end
    else
      render :update do |page|
        page << "Iyxzone.enableButton($('email_invitation_btn'),'发送邀请');"
        page << "$('email_invite').innerHTML = '发生错误';"
      end
    end
  end

  def create_multiple
    params[:emails].each do |email|
      SignupInvitation.create(:sender_id => current_user.id, :recipient_email => email)
    end
    flash[:notice] = "成功发送请求"
    render :update do |page|
      page.redirect_to :action => 'index'
    end
  end

end
