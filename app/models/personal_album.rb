class PersonalAlbum < Album

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  named_scope :not_empty, :conditions => "photos_count != 0"

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at desc', :dependent => :destroy

  has_many :latest_photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :limit => 3, :order => "created_at DESC"

  acts_as_resource_feeds :recipients => lambda {|album| 
    poster = album.poster
    fans = poster.is_idol ? poster.fans.all(:select => "users.id") : []
    friends = poster.friends.all(:select => "users.id, users.application_setting").find_all {|f| f.application_setting.recv_photo_feed?}
    ([poster.profile] + fans + friends).uniq
  }

  validates_size_of :title, :within => 1..100

end

