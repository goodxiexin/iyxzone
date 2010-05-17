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
      @current_user ||= (login_from_session) unless @current_user == false
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
      if logged_in?
        logger.error "remember_me_untils: #{current_user.remember_me_untils}"
        if current_user.remember_me_untils.blank? or current_user.remember_me_untils < Time.now
          logger.error "not logged in"
          reset_session
          login_denied
        else
          current_user.remember_me_for SESSION_DURATION
        end
      else
        logger.error "not logged in"
        login_denied
      end
    end

    def logout_required
      if logged_in?
        if current_user.remember_me_untils > Time.now
          logout_denied
        else
          reset_session
        end
      end
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
      puts "user_id:#{session[:user_id]}"
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end

  end

end
