module PrivilegeSystem

protected

  def is_owner?
    relationship == 'owner'
  end

  def is_friend?
    relationship == 'friend'
  end

  def is_same_game?
    relationship == 'same_game'
  end

  def owner_required
    is_owner? || owner_deneid
  end

  def friend_required
    is_friend? || friend_denied
  end

  def friend_or_same_game_required
    logger.error "is_friend? = #{is_friend?}"
    logger.error "is_same_game? = #{is_same_game?}"
    is_friend? || is_same_game? || friend_denied
  end

  def friend_or_owner_required
    is_friend? || is_owner? || friend_denied
  end

  def not_found
    render :template => 'not_found'
  end

  def owner_denied
    not_found
  end

  def friend_denied
    flash[:notice] = "只有他的好朋友才有权限看该资源"
    redirect_to new_friend_url(:id => @user.id)
  end

  def relationship
    @relationship unless @relationship.blank?
    if current_user == @user
      @relationship = 'owner'
    elsif @user.has_friend?(current_user) or @user.wait_for?(current_user)
      @relationship = 'friend'
    elsif @user.has_same_game_with(current_user)
      @relationship = 'same_game'
    else
      @relationship = 'stranger'
    end
    @relationship
  end
 
  def privilege_required
    return true if relationship == 'owner'
    case @privilege
    when 1 # all
      return true
    when 2 # friends or same game
      friend_or_same_game_required
    when 3 # friends
      friend_required
    else
      not_found
    end
  end

  def self.included(base)
    base.send :helper_method, :relationship, :is_owner?, :is_friend?, :owner_required, :friend_required, :friend_or_same_game_required, :friend_or_owner_required
  end

end
