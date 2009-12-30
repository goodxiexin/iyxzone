class PollInvitation < ActiveRecord::Base

	belongs_to :user, :counter_cache => :invitations_count

	belongs_to :poll

	def validate_on_create
		if poll.invitations.find_by_user_id(user_id)
			errors.add_to_base("已经邀请国了")
		end
	end

end
