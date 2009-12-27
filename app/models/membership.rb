class Membership < ActiveRecord::Base

  belongs_to :user

  belongs_to :guild

	belongs_to :president, :class_name => 'User' # obviously, this is a duplication.. however, it exists for some performance reason

	acts_as_resource_feeds

	Invitation			= 0
	VeteranRequest	= 1
	MemberRequest		= 2
	President				= 3
	Veteran					= 4
	Member					= 5

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

  def is_authorized?
    status == Membership::Member or status == Membership::Veteran
  end

  def was_authorized?
    status_was == Membership::Member or status_was == Membership::Veteran
  end  

  def validate_on_create
    membership = guild.memberships.find_by_user_id(user_id)
    return true if membership.blank?
    if membership.is_invitation?
      errors.add_to_base('你已经被邀请了')
    elsif membership.is_request?
      errors.add_to_base('你已经发送请求了')
    elsif membership.is_authorized?
      errors.add_to_base('你已经加入了该工会')
    else
			errors.add_to_base('unknown status')
		end
  end

  def validate_on_update
    unless self.is_authorized?
      errors.add_to_base('参数不对')
    end
  end

	def accept_request
		if status == Membership::VeteranRequest
			update_attribute('status', Membership::Veteran)
		elsif status == Membership::MemberRequest
			update_attribute('status', Membership::Member)
		end
	end

	def accept_invitation
		update_attribute('status', Membership::Member)
	end

  def before_create
    return if status == Membership::President
    self.president_id = guild.president.id
  end
  
end
