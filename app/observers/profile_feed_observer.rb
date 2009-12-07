class ProfileFeedObserver < ActiveRecord::Observer

	observe :profile

	def basic_info_changed? profile
		profile.gender_changed? ||
		profile.region_id_changed? ||
		profile.city_id_changed? ||
		profile.district_id_changed? ||
		profile.birthday_changed?
	end

	def contact_info_changed? profile
		profile.qq_changed? ||
		profile.phone_changed? ||
		profile.website_changed?
	end

	def after_update profile
		return unless profile.changed?
		modified = []
		modified << "基本信息" if basic_info_changed?(profile)
		modified << "联系信息" if contact_info_changed?(profile)
		return if modified.count == 0
		profile.deliver_feeds :recipients => profile.user.friends, :data => {:modified => modified}
	end

end
