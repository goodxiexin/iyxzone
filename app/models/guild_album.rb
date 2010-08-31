class GuildAlbum < Album

  belongs_to :cover, :class_name => 'GuildPhoto'

  belongs_to :guild, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'GuildPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

  has_many :latest_photos, :class_name => 'GuildPhoto', :foreign_key => 'album_id', :limit => 5, :order => "created_at DESC"

  acts_as_resource_feeds :recipients => lambda {|album| 
    poster = album.poster
    guild = album.guild
    friends = poster.friends.find_all {|f| f.application_setting.recv_photo_feed?}
    fans = poster.is_idol ? poster.fans : []
    people = guild.people.find_all {|p| p != poster and p.application_setting.recv_photo_feed?}
    (people + fans + friends).uniq
  }

  attr_readonly :privilege

end
