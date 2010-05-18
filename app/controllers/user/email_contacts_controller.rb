class User::EmailContactsController < UserBaseController

  rescue_from Contacts::TypeNotFound, :with => :render_not_supported

  rescue_from Contacts::AuthenticationError, :with => :render_authentication_error

  rescue_from Contacts::ConnectionError, :with => :render_connection_error

  def unregistered
    get_contacts

    if @contacts.blank?
      flash[:error] = '连接超时，请稍后再试'
      redirect_to signup_invitations_url
    else 
      parse_contacts
      render :update do |page|
        page.replace_html 'contacts', :partial => 'unregistered'
      end
    end
  end

  def not_friend
    get_contacts

    if @contacts.blank?
      flash[:error] = '连接超时，请稍后再试'
      redirect_to signup_invitations_url
    else
      parse_contacts
      if @not_friend_contacts.size != 0
        render :update do |page|
          page.replace_html 'contacts', :partial => 'not_friend'
        end
      else
        render :update do |page|
          page.redirect_to :controller => 'user/signup_invitations', :action => 'invite_contact'
        end
      end
    end
  end

protected

  def get_contacts
    @email_info = Rails.cache.read "import-contacts-#{current_user.id}"
    if !@email_info.blank?
      if @email_info[:contacts].blank?
        @contacts = Contacts.new(@email_info[:type], @email_info[:user_name], @email_info[:password]).contacts
        Rails.cache.write "import-contacts-#{current_user.id}", @email_info.merge({:contacts => @contacts})
      else
        @contacts = @email_info[:contacts]
      end
    end    
  end

  def render_not_supported e
    render :update do |page|
      flash[:notice] = "不支持的邮件类型"
      page.redirect_to signup_invitations_url
    end
  end

  def render_authentication_error e
    render :update do |page|
      page << "history.back();alert('用户名或者密码错误')" #.redirect_to signup_invitations_url
    end
  end

  def render_connection_error e
    render :update do |page|
      flash[:notice] = "连接错误,无法获得联系人"
      page.redirect_to signup_invitations_url
    end
  end

  def parse_contacts
    @registered_contacts = []
    @unregistered_contacts = []
    @friend_contacts = []
    @not_friend_contacts = []

    @contacts.each do |c|
      h = {:nickname => c[0], :email => c[1]}
      user = User.activated.find_by_email(c[1])
      if user.blank?
        @unregistered_contacts << h
      else
        h[:user_id] = user.id
        @registered_contacts << h
        if current_user.has_friend? user
          @friend_contacts << h
        elsif current_user != user
          @not_friend_contacts << h
        end
      end
    end
  end

end
