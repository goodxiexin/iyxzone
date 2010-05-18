class GuildAlbum < Album

  belongs_to :cover, :class_name => 'GuildPhoto'

  belongs_to :guild, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'GuildPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

  has_many :latest_photos, :class_name => 'GuildPhoto', :foreign_key => 'album_id', :limit => 5, :order => "created_at DESC"

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, album, comment| album.poster == user || comment.poster == user}

  attr_readonly :owner_id, :poster_id, :game_id, :privilege

  def record_upload user, photos
    if !photos.blank?
      update_attribute('uploaded_at', Time.now)
      if user.application_setting.emit_photo_feed?
        recipients = user.friends.find_all {|f| f.application_setting.recv_photo_feed?}
        recipients.concat guild.people.find_all {|p| p != user and p.application_setting.recv_photo_feed?}
        deliver_feeds :recipients => recipients.uniq, :data => {:ids => photos.map(&:id)}
      end
    end
  end

end
