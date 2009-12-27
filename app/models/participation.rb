class Participation < ActiveRecord::Base

  belongs_to :participant, :class_name => 'User'

  belongs_to :event

	acts_as_resource_feeds

	Invitation			= 0 # 邀请
	ConfirmRequest	= 1 # 一定去（请求)
	MaybeRequest		= 2 # 可能去（请求）
	Confirmed				= 3 # 一定去
	Maybe						= 4 # 可能去
	Declined				= 5 # 不去 

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

  def validate_on_create
    participation = event.participations.find_by_participant_id(participant_id)
    return true if participation.blank?
    if participation.is_invitation?
      errors.add_to_base('你已经被邀请了') 
    elsif participation.is_request?
      errors.add_to_base('你已经发送请求了')
    elsif participation.is_authorized?
      errors.add_to_base('你已经参加了该活动')
    else
			errors.add_to_base('unkown status')
		end
  end

  def validate_on_update
    unless self.is_authorized?
      errors.add_to_base('参数不对')
    end
  end

end
