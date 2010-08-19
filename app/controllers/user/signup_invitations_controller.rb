class User::SignupInvitationsController < UserBaseController

  layout 'app'

  def index
  end

  # 导入联系人的页面
  def prepare
    Rails.cache.write("ec-#{params[:user_name]}", params[:password])
  end

  def create
    @invitation = current_user.signup_invitations.build(:recipient_email => params[:email])
    
    if @invitation.save
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def create_multiple
    params[:emails].each do |email|
      SignupInvitation.create(:sender_id => current_user.id, :recipient_email => email)
    end
    render :json => {:code => 1}
  end

end
