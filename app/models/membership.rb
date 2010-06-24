class Membership < ActiveRecord::Base

  Invitation      = 0
  Request         = 1
  President       = 2
  Veteran         = 3
  Member          = 4

  named_scope :by, lambda {|user_ids| {:conditions => {:user_id => user_ids}}}

  named_scope :authorized, :conditions => {:status => [President, Veteran, Member]}

  belongs_to :user

  belongs_to :character, :class_name => 'GameCharacter'

  belongs_to :guild

	acts_as_resource_feeds :recipients => lambda {|membership| 
    user = membership.user
    guild = membership.guild 
    friends = membership.user.friends.find_all{|f| f.application_setting.recv_guild_feed?}
    [user.profile, guild.game] + friends + (user.is_idol ? user.fans : []) - [guild.president] 
  }

  def to_s
    if is_president?
      "会长"
    elsif is_veteran?
      "长老"
    elsif is_member?
      "会员"
    end
  end

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

  def is_president?
    status == President
  end

  def was_president?
    status_was == President
  end

  def is_veteran?
    status == Veteran
  end

  def is_member?
    status == Member
  end

  def is_authorized?
    status == Member or status == Veteran
  end

  def was_authorized?
    status_was == Member or status_was == Veteran
  end  

  def recently_change_role?
    @action == :recently_change_role
  end

  def recently_evicted?
    @action == :recently_evicted
  end

  def recently_accept_invitation?
    @action == :recently_accept_invitation
  end

  def recently_decline_invitation?
    @action == :recently_decline_invitation
  end

  def recently_accept_request?
    @action == :recently_accept_request
  end

  def recently_decline_request?
    @action == :recently_decline_request
  end

  def change_role status
    if self.status != status
      @action = :recently_change_role
      self.update_attributes(:status => status)
    end
  end

  def evict
    if self.is_authorized?
      @action = :recently_evicted
      self.destroy
    end
  end

  def accept_invitation
    if self.is_invitation?
      @action = :recently_accept_invitation
      self.update_attributes(:status => Member)
    end
  end

  def decline_invitation
    if self.is_invitation?
      @action = :recently_decline_invitation
      self.destroy
    end
  end

  def accept_request
    if self.is_request?
      @action = :recently_accept_request
      self.update_attributes(:status => Member)
    end
  end

  def decline_request
    if self.is_request?
      @action = :recently_decline_request
      self.destroy
    end
  end

  attr_readonly :user_id, :guild_id, :character_id

  validates_inclusion_of :status, :in => [Invitation, Request, President, Veteran, Member]

  validate_on_create :guild_is_valid

  validate_on_create :character_is_valid

  validate_on_create :user_is_valid

protected

  def guild_is_valid
    errors.add(:guild_id, "工会不存在") if guild.blank? #Guild.exists? guild_id
  end

  def character_is_valid
    #return if character_id.blank?
    if character.blank?
      errors.add(:character_id, "不存在")
    elsif user and !user.has_character?(character)
      errors.add(:character_id, "不属于那个人")
    end

    return if guild.blank? or character.blank? or user.blank?
   
    if is_invitation?
      errors.add(:character_id, "不能邀请") if !guild.inviteable_characters.include?(character)
    elsif is_request?
      errors.add(:character_id, "不能请求") if !guild.requestable_characters_for(user).include?(character)
    end
  end
  
  def user_is_valid
    if user.blank?
      errors.add(:user_id, '不存在')
    elsif guild
      if is_invitation?
        errors.add(:user_id, "不是好友") if !guild.can_invite?(user)
      elsif is_request?
        errors.add(:user_id, "权限不够") if !guild.is_requestable_by?(user)
      end
    end
  end

end
