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
    friends = participant.friends.all(:select => "id").find_all {|f| f.application_setting.recv_event_feed?} 
    fans = participant.is_idol ? participant.fans.all(:select => "id") : []
    ([participant.profile, event.game] + (event.is_guild_event? ? [event.guild] : []) + friends + fans - [event.poster]).uniq
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

  def recently_change_status?
    @action == :recently_change_status
  end

  def recently_evicted?
    @action == :recently_evicted
  end

  def recently_accept_request?
    @action == :recently_accept_request
  end

  def recently_decline_request?
    @action == :recently_decline_request
  end

  def recently_accept_invitation?
    @action == :recently_accept_invitation
  end

  def recently_decline_invitation?
    @action == :recently_decline_invitation
  end

  def change_status status
    if is_authorized? and self.status != status
      @action = :recently_change_status
      self.update_attributes(:status => status)
    end
  end

  def evict
    if self.is_authorized?
      @action = :recently_evicted
      self.destroy
    end
  end

  def accept_request
    if self.is_request?
      @action = :recently_accept_request
      self.update_attributes(:status => Confirmed)
    end
  end

  def decline_request
    if self.is_request?
      @action = :recently_decline_request
      self.destroy
    end
  end

  def accept_invitation status
    if self.is_invitation?
      @action = :recently_accept_invitation
      self.update_attributes(:status => status)
    end
  end

  def decline_invitation
    if self.is_invitation?
      @action = :recently_decline_invitation
      self.destroy
    end
  end

  attr_readonly :participant_id, :character_id, :event_id

  validates_inclusion_of :status, :in => [Invitation, Request, Confirmed, Maybe]

  validate_on_create :event_is_valid

  validate_on_create :character_is_valid

  validate_on_create :participant_is_valid

protected

  def event_is_valid
    if event.blank?
      errors.add(:event_id, "不存在")
    elsif event.expired?
      errors.add(:event_id, "过期了")
    end
  end  

  def character_is_valid
    if character.blank?
      errors.add(:character_id, "不存在")
    elsif participant and !participant.has_character?(character)
      errors.add(:character_id, "不属于那个人")
    end

    return if event.blank? or participant.blank?
    
    if is_invitation?
      errors.add(:character_id, "不能邀请") if !event.inviteable_characters.include?(character)
    elsif is_request?
      errors.add(:character_id, "不能请求") if !event.requestable_characters_for(participant).include?(character)
    end
  end

  def participant_is_valid
    if participant.blank?
      errors.add(:participant_id, '不存在')
    elsif event
      if is_invitation?
        errors.add(:participant_id, "不能邀请，可能不是好友或者不是这个工会的") if !event.can_invite?(participant)
      elsif is_request?
        errors.add(:participant_id, '权限不够') if !event.is_requestable_by?(participant)
      end
    end
  end

end
