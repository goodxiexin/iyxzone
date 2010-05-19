# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem

  include RoleRequirementSystem

  include Viewable::Controller

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, :with => :render_not_found

  #rescue_from RuntimeError, :with => :render_error

protected

  def render_not_found exception=nil
    render :template => "/errors/404", :status => 404, :layout => false
  end

  def render_error exception=nil
    render :template => "/errors/500", :status => 500, :layout => false
  end

  def redirect_js url
    render :update do |page|
      page.redirect_to url
    end
  end

  def render_js_code code
    render :update do |page|
      page << code
    end
  end

  def render_js_error message="发生错误"
    render :update do |page|
      page << "error('#{message}');"
    end
  end

  def render_js_tip message=''
    render :update do |page|
      page << "tip('#{message}');"
    end
  end

end
