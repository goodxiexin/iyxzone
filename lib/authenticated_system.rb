module AuthenticatedSystem

  def self.included recipient
    recipient.class_eval do 
      include AuthenticatedSystem::InstanceMethods
    end
  
    recipient.extend(AuthenticatedSystem::ClassMethods)

    recipient.send :helper_method, :current_user, :is_admin, :current_profile, :logged_in?

  end
 
  module ClassMethods
    
    def require_login opts={}
      before_filter :login_required, opts
    end

    def require_logout opts={}
      before_filter :logout_required, opts
    end

  end

  module InstanceMethods
 
  protected

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
    end

    def is_admin
      return @is_admin unless @is_admin.nil?
      @is_admin = @current_user.has_role?('admin')
      @is_admin 
    end

    def current_user=(new_user)
      session[:user_id] = new_user ? new_user.id : nil
      @current_user = new_user || false
    end

    def authorized?
      logged_in?
    end

    def login_required
      authorized? || access_denied
    end

    def logout_required
      !logged_in? || access_denied# 如果没有怎么办
    end

    def access_denied
      respond_to do |format|
        format.html do
          store_location
          if params[:at] == 'outside'
            redirect_to login_path(:at => 'outside')
          else
            redirect_to login_path
          end
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def login_from_session
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def login_from_basic_auth
      authenticate_with_http_basic do |username, password|
        self.current_user = User.authenticate(username, password)
      end
    end

    def login_from_cookie
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end

  end

end
