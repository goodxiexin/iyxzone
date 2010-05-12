# 登录过程详解
# 1) 第一次登录
# 用户连接后，由于browser传过来的cookie里什么都没有，rails系统自动创建一个session，并将该session的id存入browser的cookies['_17gaming_session']
# 用户输入密码和用户名，验证通过后，将user_id存入session[:user_id], 如果用户选择remember me, 那同时在cookies[:auth_token] = current_user.remember_token
# 2) 以后登录
# 用户输入url后，browser传过来cookie，里面有2个值，cookies['_17gaming_session']和cookies[:auth_token]。前者由rails系统自动捕获，以获得相应的session。
# 具体设置参见/config/initializers/session_store.rb。后者的用途如下：server上的session可能过期（过期的时间和你存储session的方式有关），如果过期了，
# server就不能通过cookies['_17gaming_session']里的值得到当前用户，此时可通过cookies[:auth_token]来得到当前用户（该值其实就是remember_token）
# 由此可见，auth_token就是起到一个保险的作用，记住你登录的时间长度, 最新的cookies保存方式，这个auth_token貌似有点多余

module AuthenticatedSystem

  def self.included recipient
    recipient.class_eval do 
      include AuthenticatedSystem::InstanceMethods
    end
  
    recipient.extend(AuthenticatedSystem::ClassMethods)

    recipient.send :helper_method, :current_user, :is_admin, :logged_in?

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
      !logged_in? || logout_denied# 如果没有怎么办
    end

    def logout_denied
      flash[:error] = '只有登出才能进行此操作'
      if request.env["HTTP_REFERER"]
        redirect_to :back
      else
        render :template => "/errors/logout_required", :status => 404, :layout => false
      end
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
