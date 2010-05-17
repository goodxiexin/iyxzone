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
      @current_user ||= (login_from_session || login_from_cookie) unless @current_user == false
    end

    def is_admin
      return @is_admin unless @is_admin.nil?
      @is_admin = current_user.has_role?('admin')
      @is_admin 
    end

    def current_user=(new_user)
      session[:user_id] = new_user ? new_user.id : nil
      @current_user = new_user || false
    end

    def login_required
      logged_in? || login_denied
    end

    def logout_required
      !logged_in? || logout_denied
    end

    def login_denied
      respond_to do |format|
        format.html do
          session[:return_to] = request.request_uri
          if params[:at] == 'outside'
            redirect_to login_path(:at => 'outside')
          else
            redirect_to login_path
          end
        end
      end
    end

    def logout_denied
      flash[:error] = '只有登出才能进行此操作'
      if request.env["HTTP_REFERER"]
        redirect_to :back
      else
        render :template => "/errors/logout_required", :status => 404, :layout => false
      end
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def login_from_session
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def login_from_cookie
      user = cookies[:auth_token] && User.find_by_invite_code(cookies[:auth_token])
      if user and user.invite_code
        self.current_user = user
        remember_me_in_cookie
        self.current_user
      end
    end

    def remember_me_in_cookie
      cookies[:auth_token] = {:value => current_user.invite_code, :expires => REMEMBER_DURATION.from_now}
    end

  end

end
