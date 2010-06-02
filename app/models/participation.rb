class Participation < ActiveRecord::Base

  Invitation      = 0 # 邀请
  Request         = 1 # 请求 
  Confirmed       = 3 # 一定去
  Maybe           = 4 # 可能去

  named_scope :by, lambda {|user_ids| {:conditions => {:participant_id => user_ids}}}

  named_scope :authorized, :conditions => {:status => [Confirmed, Maybe]}

  belongs_to :participant, :class_name => 'User'

  belongs_to :character, :class_name => 'GameCharacter'

  belongs_to :event

	acts_as_resource_feeds :recipients => lambda {|participation|
    participant = participation.participant
    event = participation.event
    friends = participant.friends.find_all {|f| f.application_setting.recv_event_feed?} 
    fans = participant.is_idol ? participant.fans : []
    [participant.profile, event.game] + (event.is_guild_event? ? [event.guild] : []) + friends + fans - [event.poster]
  }

  def is_invitation?
    status == Invitation
  end

  def was_invitation?
    status_was == Invitation
  end
  
  def is_request?
    status == Request
  end

  def was_request?
    status_was == Request
  end

  def is_confirmed?
    status == Confirmed
  end

  def is_authorized?
    status == Confirmed or status == Maybe
  end

  def was_authorized?
    status_was == Confirmed or status_was == Maybe
  end

  attr_accessor :recently_change_status

  attr_accessor :recently_evicted

  attr_accessor :recently_accept_request

  attr_accessor :recently_decline_request

  attr_accessor :recently_accept_invitation

  attr_accessor :recently_decline_invitation

  def change_status status
    if self.status != status
      self.recently_change_status = true
      self.update_attributes(:status => status)
    end
  end

  def evict
    if self.is_authorized?
      self.recently_evicted = true
      self.destroy
    end
  end

  def accept_request
    if self.is_request?
      self.recently_accept_request = true
      self.update_attributes(:status => Confirmed)
    end
  end

  def decline_request
    if self.is_request?
      self.recently_decline_request = true
      self.destroy
    end
  end

  def accept_invitation status
    if self.is_invitation?
      self.recently_accept_invitation = true
      self.update_attributes(:status => status)
    end
  end

  def decline_invitation
    if self.is_invitation?
      self.recently_decline_invitation = true
      self.destroy
    end
  end

  # participant_id, character_id, event_id 都是不能修改的
  attr_readonly :participant_id, :character_id, :event_id

  validates_presence_of :participant_id, :message => "不能为空", :on => :create

  validates_presence_of :character_id, :message => "不能为空", :on => :create

  validates_presence_of :event_id, :message => "不能为空", :on => :create

  validates_inclusion_of :status, :message => "只能是0,1,3,4", :in => [Invitation, Request, Confirmed, Maybe]

  validate_on_create :event_is_valid

  validate_on_create :character_is_valid

  validate_on_create :participant_is_valid

  validate_on_update :status_is_valid

protected

  def event_is_valid
    return if event_id.blank?

    if !event.blank?
      errors.add(:event_id, "过期了") if event.expired?
    else
      errors.add(:event_id, "不存在")
    end
  end  

  def character_is_valid
    return if character_id.blank?
    
    if character.blank?
      errors.add(:character_id, "不存在")
    elsif event and (character.game_id != event.game_id or character.area_id != event.game_area_id or character.server_id != event.game_server_id)
      errors.add(:character_id, "不属于相应服务器")
    end
  end

  def participant_is_valid
    return if event.blank? or participant.blank? or character.blank?

    participation = event.participation_for participant, character

    if participation.blank?
      if is_invitation?
        if event.guild.nil?
          errors.add(:participant_id, '不能邀请非好友') if !event.poster.has_friend?(participant_id)
        else
          errors.add(:participant_id, '不能邀请不是这个工会的人') if !event.guild.has_people?(participant)
        end
      elsif is_request?
        errors.add(:participant_id, '权限不够') unless event.is_requestable_by? participant
      elsif is_authorized?
        errors.add(:participant_id, '不能直接创建') unless event.poster_id == participant_id
      end
    else
      if participation.is_invitation?
        errors.add(:participant_id, '已经被邀请了') 
      elsif participation.is_request?
        errors.add(:participant_id, '已经发送请求了')
      elsif participation.is_authorized?
        errors.add(:participant_id, '已经参加了该活动')
		  end
    end
  end

  def status_is_valid
    return if status.blank?  
 
    if is_invitation?
      errors.add(:status, '不能从请求变成邀请') if was_request?
      errors.add(:status, '不能从参加变成邀请') if was_authorized?
    elsif is_request?
      errors.add(:status, '不能从邀请变成请求') if was_invitation?
      errors.add(:status, '不能从参加变成请求') if was_authorized?
    end 
  end

end
