class EventAlbum < Album

  belongs_to :cover, :class_name => 'EventPhoto'

  belongs_to :event, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

  has_many :latest_photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :limit => 5, :order => "created_at DESC"

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, album, comment| album.poster == user || comment.poster == user}

  # 这些属性都是系统创建的，不需要检查
  attr_readonly :game_id, :poster_id, :owner_id, :privilege

	def record_upload user, photos
    if !photos.blank?
      update_attribute('uploaded_at', Time.now)
    end
	  if user.application_setting.emit_photo_feed == 1
      recipients = user.friends.find_all {|f| f.application_setting.recv_photo_feed == 1}
			recipients.concat event.participants.find_all {|p| (p != user) and p.application_setting.recv_photo_feed == 1}
			deliver_feeds :recipients => recipients.uniq, :data => {:ids => photos.map(&:id), :poster_id => user.id}
    end
	end

end
