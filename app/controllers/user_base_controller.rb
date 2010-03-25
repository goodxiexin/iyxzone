class UserBaseController < ApplicationController

  before_filter :login_required

  before_filter :setup_verify_scope

  before_filter :setup_instant_messenger

  before_filter :set_last_seen_at

  before_filter :setup

protected

  def user_game_conds
    {:game_id => current_user.characters.map(&:game_id).uniq}
  end
  
  def setup_verify_scope
    # 下面这些资源，在user里都只能看到审核通过的
    [Comment, Event, Guild, Photo, PhotoTag, Sharing, Status, Video].each do |klass|
      klass.enable_verify_scope
    end
  end

  def setup_instant_messenger
    @my_info = {:avatar => avatar_path(current_user), :login => current_user.login}
    @online_friends = current_user.online_friends.map {|f| {:login => f.login, :id => f.id, :avatar => avatar_path(f), :pinyin => f.pinyin}}
    @unread_messages = {}
    current_user.unread_messages.group_by(&:poster).each do |poster, messages|
      @unread_messages["#{poster.id}"] = {
        :login => poster.login,
        :avatar => avatar_path(poster),
        :messages => messages.map{|m| {:content => m.content, :created_at => m.created_at, :id => m.id}}
      }
    end
  end

  def set_last_seen_at
    current_user.last_seen_at = Time.now
    current_user.save
  end

  def setup
    # override this method in child controller
  end

  def require_owner owner
    owner == current_user || render_not_found
  end

  def require_none_owner owner
    owner != current_user || render_not_found
  end

  def require_friend owner
    owner.relationship_with(current_user) == 'friend' || render_add_friend(owner)
  end

  def require_none_friend owner
    owner.relationship_with(current_user) != 'friend' || render_not_found
  end

  def require_friend_or_owner owner
    relationship = owner.relationship_with current_user
    relationship == 'friend' || relationship == 'owner' || render_add_friend(owner)
  end

  def require_adequate_privilege resource
    resource.available_for?(current_user) || render_privilege_denied(resource)
  end

  def render_privilege_denied resource
    if resource.is_owner_privilege?
      render_not_found
    else
      render_add_friend resource.resource_owner
    end
  end

  def render_add_friend friend
    redirect_to new_friend_url(:uid => friend.id) 
  end

  def avatar_path user
    if user.avatar.blank?
      "/images/default_medium.png"
    else
      user.avatar.public_filename(:medium)
    end
  end

end
