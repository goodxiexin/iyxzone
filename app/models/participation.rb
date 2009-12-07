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

  def validate_on_create
    participation = event.participations.find_by_participant_id(participant_id)
    return true if participation.blank?
    if participation.status == Participation::Invitation
      errors.add_to_base('你已经被邀请了') 
    elsif participation.status == Participation::ConfirmRequest or participation.status == Participation::MaybeRequest
      errors.add_to_base('你已经发送请求了')
    elsif participaton.status == Participation::Confirmed or participaton.status == Participation::Maybe or participaton.status == Participation::Declined
      errors.add_to_base('你已经参加了该活动')
    else
			errors.add_to_base('unkown status')
		end
  end

end
