class AvatarAlbum::DigsController < DigsController

protected

	def catch_diggable
		@diggable = Avatar.find(params[:avatar_id])
	rescue
		not_found
	end

end
