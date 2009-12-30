# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem

  include PrivilegeSystem

  include RoleRequirementSystem

  def user_game_conds
    {:game_id => current_user.characters.map(&:game_id).uniq}
  end

end
