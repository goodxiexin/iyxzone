class UserBaseController < ApplicationController

  include PrivilegeSystem

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

  def self.require_owner opts
    before_filter opts do |controller|
      user = controller.instance_variable_get("@user")
      current_user = controller.send(:current_user)
      user == current_user || controller.render_not_found
    end
  end

  def self.require_none_owner opts
    before_filter opts do |controller|
      user = controller.instance_variable_get("@user")
      current_user = controller.send(:current_user)
      user != current_user || controller.render_not_found
    end  
  end

  def self.require_friend opts
    before_filter opts do |controller|
      user = controller.instance_variable_get("@user")
      current_user = controller.send(:current_user)
      user.relationship_with(current_user) == 'friend' || controller.render_not_found
    end
  end

  def self.require_none_friend opts
    before_filter opts do |controller|
      user = controller.instance_variable_get("@user")
      current_user = controller.send(:current_user)
      user.relationship_with(current_user) != 'friend' || controller.render_not_found
    end
  end

  def self.require_friend_or_owner opts
    before_filter opts do |controller|
      user = controller.instance_variable_get("@user")
      current_user = controller.send(:current_user)
      relationship = user.relationship_with current_user
      relationship == 'friend' || relationship == 'owner' || controller.render_not_found
    end
  end

  def self.require_adequate_privilege resource, opts
    before_filter opts do |controller|
      current_user = controller.send(:current_user)
      resource = controller.instance_variable_get("@#{resource}")
      resource.available_for? current_user || controller.render_not_found
    end
  end

  def render_privilege_denied
    render :template => 'not_found'
  end

  def render_not_found
    render :template => 'not_found'
  end

end
