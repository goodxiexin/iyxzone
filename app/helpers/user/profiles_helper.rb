module User::ProfilesHelper

  def character_info_viewable?
    is_owner? || relationship == 'friend' || @setting.character_info == 1 || (@setting.character_info == 2 and relationship == 'same_game')
  end

  def wall_viewable?
    is_owner? || relationship == 'friend' || @setting.wall == 1 || (@setting.wall == 2 and relationship == 'same_game')
  end

  def basic_info_viewable?
    is_owner? || relationship == 'friend' || @setting.basic_info == 1 || (@setting.basic_info == 2 and relationship == 'same_game')
  end

  def email_viewable?
    is_owner? || relationship == 'friend' || @setting.email == 1 || (@setting.email == 2 and relationship == 'same_game')
  end

  def qq_viewable?
    is_owner? || relationship == 'friend' || @setting.qq == 1 || (@setting.qq == 2 and relationship == 'same_game')
  end

  def phone_viewable?
    is_owner? || relationship == 'friend' || @setting.phone == 1 || (@setting.phone == 2 and relationship == 'same_game')
  end

  def website_viewable?
    is_owner? || relationship == 'friend' || @setting.website == 1 || (@setting.website == 2 and relationship == 'same_game')
  end  

end
