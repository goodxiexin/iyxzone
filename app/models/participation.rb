class Participation < ActiveRecord::Base

  belongs_to :participant, :class_name => 'User'

  belongs_to :event

  has_many :notifications, :as => 'notifier'

	acts_as_resource_feeds

	Invitation			= 0 # 邀请
	ConfirmRequest	= 1 # 一定去（请求)
	MaybeRequest		= 2 # 可能去（请求）
	Confirmed				= 3 # 一定去
	Maybe						= 4 # 可能去
	Declined				= 5 # 不去 

  def to_s
    if is_invitation?
      "受邀请"
    elsif is_request?
      "等待回复"
    elsif status == 3
      "一定去"
    elsif status == 4
      "可能去"
    elsif status == 5
      "去他娘的"
    end
  end

  def is_invitation?
    status == Participation::Invitation
  end

  def was_invitation?
    status_was == Participation::Invitation
  end
  
  def is_request?
    status == Participation::ConfirmRequest or status == Participation::MaybeRequest
  end

  def was_request?
    status_was == Participation::ConfirmRequest or status_was == Participation::MaybeRequest
  end

  def is_confirmed?
    status == Participation::Confirmed
  end

  def is_authorized?
    status == Participation::Confirmed or status == Participation::Maybe or status == Participation::Declined
  end

  def was_authorized?
    status_was == Participation::Confirmed or status_was == Participation::Maybe or status_was == Participation::Declined  
  end

  def accept
    update_attributes(:status => status + 2)
  end

  def validate
    # check participant
    errors.add_to_base('参与者不能为空') if participant_id.blank?
    
    # check event
    if event_id.blank?
      errors.add_to_base('活动不能为空')
    elsif Event.find(:first, :conditions => {:id => event_id}).nil?
      errors.add_to_base('活动不存在')
    end

    # check status
    if status.blank?
      errors.add_to_base('状态不能为空')
    elsif !is_authorized? and !is_request? and !is_invitation?
      errors.add_to_base('状态不对')
    end
  end

  def validate_on_create
    return unless errors.on_base.blank?
    participation = event.participations.find_by_participant_id(participant_id)
    if participation.blank?
      if is_invitation?
        errors.add_to_base('不能邀请非好友') if !event.poster.has_friend?(participant_id)
      elsif is_request?
        errors.add_to_base('权限不够') unless event.requestable_by participant
      #elsif is_authorized?
      #  errors.add_to_base('不能擅自创建') unless event.poster == participant
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
    
    if is_invitation?
      errors.add_to_base('不能从请求变成邀请') if was_request?
      errors.add_to_base('不能从参加变成邀请') if was_authorized?
    elsif is_request?
      errors.add_to_base('不能从邀请变成请求') if was_invitation?
      errors.add_to_base('不能从参加变成请求') if was_authorized?
    end 
  end

end
