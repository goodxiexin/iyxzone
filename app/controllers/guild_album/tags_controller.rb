class GuildAlbum::TagsController < PhotoTagsController
	
	before_filter :member_required, :only => [:create]

protected

	def catch_photo
		@photo = GuildPhoto.find(params[:guild_photo_id])
		@album = @photo.album
		@guild = @album.guild
		@membership = @guild.memberships.find_by_user_id(current_user.id)
	rescue
		not_found
	end

	def member_required
		[3,4,5].include? @membership.status || not_found
	end

end
