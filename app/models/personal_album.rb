class PersonalAlbum < Album

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id', :counter_cache => :personal_albums_count

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	named_scope :recent, :conditions => "privilege != 4", :order => 'uploaded_at DESC'

	acts_as_privileged_resources

	def record_upload user, photos
	  if user.application_setting.emit_photo_feed and privilege != 4
			recipients = [].concat user.guilds
			recipients.concat user.friends.find_all{|f| f.application_setting.recv_photo_feed}
			deliver_feeds :recipients => recipients, :data => {:ids => photos.map(&:id)}
      update_attribute('uploaded_at', Time.now)
    end
	end	

end

