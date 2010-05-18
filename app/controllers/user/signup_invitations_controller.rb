class User::SignupInvitationsController < UserBaseController

  layout 'app'

  def index
  end

  # 把这些写到cache里而不是session里，因为session storage是cookie，所以密码这样放是不安全的
  def add_friend
    Rails.cache.write "import-contacts-#{current_user.id}", {:user_name => params[:user_name], :type => params[:type], :password => params[:password]}
  end

  def invite_contact
    @email_info = Rails.cache.read "import-contacts-#{current_user.id}"
    
    if !@email_info.blank?
      @type = @email_info[:type]
      @user_name = @email_info[:user_name]
    else
      flash[:error] = '发生错误，可能是连接失败，请重新输入'
      redirect_to :action => :index
    end
  end

  def create
    @invitation = current_user.signup_invitations.build(:recipient_email => params[:email])
    
    if @invitation.save
      render_js_tip '发送成功'
    else
      render_js_error
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
