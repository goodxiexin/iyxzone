class User::EmailContactsController < UserBaseController

  rescue_from Contacts::TypeNotFound, :with => :render_not_supported

  rescue_from Contacts::AuthenticationError, :with => :render_authentication_error

  rescue_from Contacts::ConnectionError, :with => :render_connection_error

  def parse
    @password = Rails.cache.read("ec-#{params[:user_name]}")
    @contacts = Contacts.new(params[:type], params[:user_name], @password).contacts
    @contacts.map! do |c|
      h = {:nickname => c[0], :email => c[1]}
      user = User.activated.find_by_email(c[1])
      if user.blank?
        h[:registered] = false
      else
        h[:registered] = true
        h[:user_id] = user.id
        if current_user.has_friend? user
          h[:is_friend] = true
        elsif current_user != user
          h[:is_friend] = false
          h[:avatar] = user.avatar.nil? ? "/images/default_#{user.gender}_cmedium.png" : user.avatar.public_filename(:cmedium)
       end
      end
      h
    end
    render :json => {:code => 1, :contacts => @contacts}
  end

protected

  def render_not_supported e
    render :json => {:code => 2}
  end

  def render_authentication_error e
    render :json => {:code => 3}
  end

  def render_connection_error e
    render :json => {:code => 4}
  end

end
