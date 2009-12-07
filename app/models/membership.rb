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

	def before_create
		return if status == Membership::President
		self.president_id = guild.president.id
	end

  def validate_on_create
    membership = guild.memberships.find_by_user_id(user_id)
    return true if membership.blank?
    if membership.status == Membership::Invitation
      errors.add_to_base('你已经被邀请了')
    elsif membership.status == Membership::VeteranRequest or membership.status == Membership::MemberRequest
      errors.add_to_base('你已经发送请求了')
    elsif membership.status == Membership::President or membership.status == Membership::Veteran or membership.status == Membership::Member
      errors.add_to_base('你已经加入了该工会')
    else
			errors.add_to_base('unknown status')
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

end
