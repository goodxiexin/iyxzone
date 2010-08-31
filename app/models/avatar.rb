class Avatar < Photo

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :clarge => 'crop: 100x100', :cmedium => 'crop: 50x50', :csmall => 'crop: 25x25'}

  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user}, 
                         :create_conditions => lambda {|user, photo, album| album.poster == user || album.poster.has_friend?(user)},
                         :candidates => lambda {|tagger, photo, album| [tagger] + tagger.friends}

  acts_as_resource_feeds :recipients => lambda {|photo| 
    poster = photo.album.poster
    (poster.friends.find_all{|f| f.application_setting.recv_photo_feed?} + (poster.is_idol ? poster.fans : [])).uniq
  }
  
  attr_readonly :album_id

end
