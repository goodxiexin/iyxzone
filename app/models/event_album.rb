class EventAlbum < Album

  belongs_to :cover, :class_name => 'EventPhoto'

  belongs_to :event, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

  has_many :latest_photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :limit => 5, :order => "created_at DESC"

  attr_readonly :privilege

  acts_as_resource_feeds :recipients => lambda {|album| 
    poster = album.poster
    event = album.event
    fans = poster.is_idol ? poster.fans.all(:select => "users.id") : []
    friends = poster.friends.all(:select => "users.id, users.application_setting").find_all {|f| f.application_setting.recv_photo_feed?}
    participants = event.participants.all(:select => "users.id, users.application_setting").find_all {|p| p != poster and p.application_setting.recv_photo_feed?} 
    ([poster.profile] + fans + friends + participants).uniq
  }

end
