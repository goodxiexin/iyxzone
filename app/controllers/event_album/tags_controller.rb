class EventAlbum::TagsController < PhotoTagsController

	before_filter :participant_required, :only => [:create]

protected

	def catch_photo
		@photo = EventPhoto.find(params[:event_photo_id])
		@album = @photo.album
		@event = @album.event
		@user = @album.poster
	rescue
		not_found
	end

	def participant_required
		@event.participants.include?(current_user) || not_found
	end

end
