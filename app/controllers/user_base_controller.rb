class UserBaseController < ApplicationController

  include PrivilegeSystem

  include RoleRequirementSystem

  before_filter :login_required

  before_filter :setup_instant_messenger

  before_filter :setup

protected

  def user_game_conds
    {:game_id => current_user.characters.map(&:game_id).uniq}
  end
  
  def setup_instant_messenger
    @online_friends = current_user.online_friends
    @im_info = {}
    current_user.unread_messages.group_by(&:poster).each do |poster, messages|
      @im_info["#{poster.id}"] = {
        :login => poster.login, 
        :messages => messages.map{|m| {:content => m.content, :created_at => m.created_at, :id => m.id}}
      }
    end
  end

  def setup
    # override this method in child controller
  end

  def require_owner opts
    before_filter opts do |controller|
      @user == current_user || render_not_found
    end
  end

  def require_none_owner opts
    before_filter opts do |controller|
      @user != current_user || render_not_found
    end  
  end

  def require_friend opts
    before_filter opts do |controller|
      @user.relationship_with(current_user) == 'friend' || render_not_found
    end
  end

  def require_none_friend opts
    before_filter opts do |controller|
      @user.relationship_with(current_user) != 'friend' || render_not_found
    end
  end

  def require_friend_or_owner opts
    before_filter opts do |controller|
      relationship = @user.relationship_with current_user
      relationship == 'friend' || relationship == 'owner' || render_not_found
    end
  end

  def require_adequate_privilege resource, opts
    before_filter opts do |controller|
      eval("@#{resource}").available_for? current_user || render_not_found
    end
  end

  def render_privilege_denied
    render :template => 'not_found'
  end

  def render_not_found
    render :template => 'not_found'
  end

end
