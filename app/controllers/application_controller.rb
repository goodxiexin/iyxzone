# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem

  include RoleRequirementSystem

	unless ActionController::Base.consider_all_requests_local
		rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction, :with => :render_not_found
		rescue_from RuntimeError, :with => :render_error
	end

protected

  def render_not_found(exception)
	  log_error(exception)
		render :template => "/errors/404.html.erb", :status => 404, :layout => "app"
	end

	def render_error(exception)
		log_error(exception)
		render :template => "/errors/500.html.erb", :status => 500, :layout => 'app'
	end

end
