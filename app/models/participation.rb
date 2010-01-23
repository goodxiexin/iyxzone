class Participation < ActiveRecord::Base

  belongs_to :participant, :class_name => 'User'

  belongs_to :character, :class_name => 'GameCharacter'

  belongs_to :event

  has_many :notifications, :as => 'notifier', :dependent => :destroy

	acts_as_resource_feeds

	Invitation			= 0 # 邀请
  Request         = 1 # 请求 
	Confirmed				= 3 # 一定去
	Maybe						= 4 # 可能去
  Expired         = 5 # 过期的请求或者邀请

  def to_s
    if is_invitation?
      "受邀请"
    elsif is_request?
      "等待回复"
    elsif status == 3
      "一定去"
    elsif status == 4
      "可能去"
    end
  end

  def is_invitation?
    status == Participation::Invitation
  end

  def was_invitation?
    status_was == Participation::Invitation
  end
  
  def is_request?
    status == Participation::Request
  end

  def was_request?
    status_was == Participation::Request
  end

  def is_confirmed?
    status == Participation::Confirmed
  end

  def is_authorized?
    status == Participation::Confirmed or status == Participation::Maybe
  end

  def was_authorized?
    status_was == Participation::Confirmed or status_was == Participation::Maybe
  end

  def is_expired?
    status == Participation::Expired
  end

  # participant_id, character_id, event_id 都是不能修改的
  
  def validate
    # check status
    if status.blank?
      errors.add_to_base('状态不能为空')
      return
    elsif !is_authorized? and !is_request? and !is_invitation?
      errors.add_to_base('状态不对')
      return
    end
  end

  def validate_on_create
    return unless errors.on_base.blank?

    # participant_id 是 current_user.id 不用检查

    # check event
    if event_id.blank?
      errors.add_to_base('活动不能为空')
      return
    elsif Event.find(:first, :conditions => {:id => event_id}).blank?
      errors.add_to_base('活动不存在')
      return
    end

    # check character
    if character_id.blank?
      errors.add_to_base("没有游戏角色")
      return
    else
      c = GameCharacter.find(:first, :conditions => {:id => character_id, :user_id => participant_id})
      if c.blank?
        errors.add_to_base("游戏角色不存在")
        return
      elsif c.game_id != event.game_id or c.area_id != event.game_area_id or c.server_id != event.game_server_id
        errors.add_to_base("游戏角色和活动不匹配")
        return
      end
    end

    # check if this is allowed to be created
    participation = event.participations.find(:first, :conditions => {:participant_id => participant_id, :character_id => character_id})

    if participation.blank?
      if is_invitation?
        errors.add_to_base('不能邀请非好友') if !event.poster.has_friend?(participant_id)
      elsif is_request?
        errors.add_to_base('权限不够') unless event.requestable_by? participant
      elsif is_authorized?
        errors.add_to_base('不能直接创建') unless event.poster_id == participant_id
      end
    else
      if participation.is_invitation?
        errors.add_to_base('已经被邀请了') 
      elsif participation.is_request?
        errors.add_to_base('已经发送请求了')
      elsif participation.is_authorized?
        errors.add_to_base('已经参加了该活动')
		  end
    end
  end

  def validate_on_update
    return unless errors.on_base.blank?
   
    if participant_id_changed?
      errors.add_to_base("不能修改participant_id")
    elsif event_id_changed?
      errors.add_to_base("不能修改event_id")
    elsif character_id_changed?
      errors.add_to_base("不能修改character_id")
    end
 
    if is_invitation?
      errors.add_to_base('不能从请求变成邀请') if was_request?
      errors.add_to_base('不能从参加变成邀请') if was_authorized?
    elsif is_request?
      errors.add_to_base('不能从邀请变成请求') if was_invitation?
      errors.add_to_base('不能从参加变成请求') if was_authorized?
    end 
  end

end
