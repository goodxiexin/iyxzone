class UserBaseController < ApplicationController

  # 临时家出来的，为了让别人改名字
  before_filter :need_change_nickname

  before_filter :login_required

  before_filter :set_last_seen_at

  before_filter :setup

protected

  def need_change_nickname
    record = InvalidName.find_by_user_id current_user.id
    if !record.nil?
      redirect_to "/change_nick_name/#{record.token}"
    end
  end

  def user_game_conds
    {:game_id => current_user.characters.map(&:game_id).uniq}
  end
  
  def set_last_seen_at
    current_user.update_attribute(:last_seen_at, Time.now)
  end

  def setup
    # override this method in child controller
  end

  def require_owner owner
    owner == current_user || is_admin || render_not_found
  end

  def require_none_owner owner
    owner != current_user || is_admin || render_not_found
  end

  def require_friend owner
    current_user.relationship_with(owner) == 'friend' || is_admin || render_add_friend(owner)
  end

  def require_none_friend owner
    current_user.relationship_with(owner) != 'friend' || is_admin || render_not_found
  end

  def require_friend_or_owner owner
    relationship = current_user.relationship_with(owner)
    relationship == 'friend' || relationship == 'owner' || is_admin || render_add_friend(owner)
  end

  def require_adequate_privilege resource, relationship
    resource.available_for?(relationship) || is_admin || render_privilege_denied(resource)
  end

  def require_verified resource
    if resource.rejected? and !is_admin
      respond_to do |format|
        format.js { render_js_error '该资源已经被和谐' } 
        format.html { render_not_found }
      end
    end 
  end

  def render_privilege_denied resource
    if resource.is_owner_privilege? #自己
      render_not_found
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

end
