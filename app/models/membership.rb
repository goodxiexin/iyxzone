class Membership < ActiveRecord::Base

  belongs_to :user

  belongs_to :guild

  has_many :notifications, :as => 'notifier'

	acts_as_resource_feeds

	Invitation			= 0
	VeteranRequest	= 1
	MemberRequest		= 2
	President				= 3
	Veteran					= 4
	Member					= 5

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
    status == Membership::Invitation
  end

  def was_invitation?
    status_was == Membership::Invitation
  end

  def is_request?
    status == Membership::VeteranRequest or status == Membership::MemberRequest
  end

  def was_request?
    status_was == Membership::VeteranRequest or status_was == Membership::MemberRequest
  end

  def is_president?
    status == Membership::President
  end

  def was_president?
    status_was == Membership::President
  end

  def is_veteran?
    status == Membership::Veteran
  end

  def is_member?
    status == Membership::Member
  end

  def is_authorized?
    status == Membership::Member or status == Membership::Veteran
  end

  def was_authorized?
    status_was == Membership::Member or status_was == Membership::Veteran
  end  

  def accept_request
    update_attributes(:status => status + 3)
  end

  def accept_invitation
    update_attributes(:status => Membership::Member)
  end

  def validate
    # check user
    if user_id.blank?
      errors.add_to_base('用户不能为空')
      return
    end

    # check guild
    if guild_id.blank?
      errors.add_to_base('没有工会')
      return
    elsif Guild.find(:first, :conditions => {:id => guild_id}).nil?
      errors.add_to_base('工会不存在')
      return
    end

    # check status
    if status.blank?
      errors.add_to_base('状态不能为空')
    else
      errors.add_to_base('状态不对') if !is_authorized? and !is_president? and !is_request? and !is_invitation? 
    end
  end

  def validate_on_create
    return unless errors.on_base.blank?
    membership = guild.memberships.find_by_user_id(user_id)
    if membership.blank?
      if is_invitation?
        errors.add_to_base('不能邀请非好友') if guild_id and !guild.president.has_friend?(user_id)
      elsif is_request?
        # 每个工会谁都可以请求加入
      #else
        # 不能直接创建
      end
    else
      if membership.is_invitation?
        errors.add_to_base('已经被邀请了')
      elsif membership.is_request?
        errors.add_to_base('已经发送请求了')
      elsif membership.is_authorized? or membership.is_president?
        errors.add_to_base('已经加入了该工会')
      end
		end
  end

  def validate_on_update
    return unless errors.on_base.blank?
    
    if is_invitation?
      errors.add_to_base('不能从请求变成邀请') if was_request?
      errors.add_to_base('不能从参加变成邀请') if was_authorized? or was_president?
    elsif is_request?
      errors.add_to_base('不能从邀请变成请求') if was_invitation?
      errors.add_to_base('不能从参加变成请求') if was_authorized? or was_president?
    elsif is_authorized?
    end
  end

end
