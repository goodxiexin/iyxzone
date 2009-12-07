# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem

  include PrivilegeSystem

  def new_validation_image
    validation_image = ValidationImage.new
    session[:validation_text] = validation_image.text
    send_data validation_image.image, :type => 'image/jpeg', :disposition => 'inline'
  end 

end
