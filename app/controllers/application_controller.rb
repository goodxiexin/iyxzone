# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem

  include RoleRequirementSystem

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, :with => :render_not_found

  #rescue_from RuntimeError, :with => :render_error

protected

  def render_not_found exception=nil
    render :template => "/errors/404", :status => 404, :layout => false
  end

  def render_error exception=nil
    render :template => "/errors/500", :status => 500, :layout => false
  end

end
