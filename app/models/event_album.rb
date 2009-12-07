class EventAlbum < Album

  belongs_to :cover, :class_name => 'EventPhoto'

  belongs_to :event, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	def record_upload user, photos
	  if user.application_setting.emit_photo_feed
			recipients = event.participants.find_all {|p| (p != user) and p.application_setting.recv_photo_feed }
			deliver_feeds :recipients => recipients, :data => {:ids => photos.map(&:id), :poster_id => user.id}
			update_attribute('uploaded_at', Time.now)
    end
	end

end
