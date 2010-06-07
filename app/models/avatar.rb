class Avatar < Photo

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :medium => '50x50>', :small => '27x27>'}

  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user}, 
                         :create_conditions => lambda {|user, photo, album| album.poster.has_friend?(user) || album.poster == user}

  acts_as_resource_feeds :recipients => lambda {|photo| 
    poster = photo.album.poster
    poster.friends.find_all{|f| f.application_setting.recv_photo_feed?} + (poster.is_idol ? poster.fans : [])
  }
  
  attr_readonly :album_id, :privilege

end
