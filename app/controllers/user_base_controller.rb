class UserBaseController < ApplicationController

  before_filter :login_required

  before_filter :setup_verify_scope

  before_filter :set_last_seen_at

  before_filter :setup

protected

  def user_game_conds
    {:game_id => current_user.characters.map(&:game_id).uniq}
  end
  
  def setup_verify_scope
    # 下面这些资源，在user里都只能看到审核通过的
    [Comment, Blog, Event, Guild, Photo, PhotoTag, Status, Video].each do |klass|
 #     klass.enable_verify_scope
    end
  end

  def set_last_seen_at
    current_user.update_attribute(:last_seen_at, Time.now)
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
    if resource.is_owner_privilege? #自己
      render_not_enough_privilege
    else
      render_add_friend resource.resource_owner
    end
  end

  def render_not_enough_privilege
    render :template => "/errors/402", :status => 402, :layout => false
  end

  def render_add_friend friend
    flash[:notice] = '只有TA的好友才有权限查看该资源'
    redirect_to new_friend_url(:uid => friend.id) 
  end

  def avatar_path user
    if user.avatar.blank?
      "/images/default_medium.png"
    else
      user.avatar.public_filename(:medium)
    end
  end

  def get_privilege_cond relationship
    if relationship == 'owner'
      {:privilege => [1,2,3,4]}
    elsif relationship == 'friend'
      {:privilege => [1,2,3]}
    elsif relationship == 'same_game'
      {:privilege => [1,2]}
    else
      {:privilege => 1}
    end
  end

end
