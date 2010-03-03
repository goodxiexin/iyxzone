class UserBaseController < ApplicationController

  include PrivilegeSystem

  include RoleRequirementSystem

  before_filter :login_required

  before_filter :get_online_friends

  before_filter :set_last_seen_at

  before_filter :setup

protected

  def user_game_conds
    {:game_id => current_user.characters.map(&:game_id).uniq}
  end
  
  def get_online_friends
    @online_friends = current_user.online_friends
  end

  def set_last_seen_at
    current_user.update_attribute(:last_seen_at, Time.now.to_s(:db)) 
  end

  def setup
    # override this method in child controller
  end

  def record_not_found
    render :template => 'record_not_found'
  end



end
