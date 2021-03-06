class PersonalPhoto < Photo

	has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :clarge => 'crop: 100x100', :cmedium => 'crop: 50x50', :csmall => 'crop: 25x25'}
                                  
  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user },
                         :create_conditions => lambda {|user, photo, album| album.poster == user || (!album.is_owner_privilege? and album.poster.has_friend?(user))},
                         :candidates => lambda {|tagger, photo, album| [tagger] + tagger.friends} 

  def self.migrate opts={}
    from = opts[:from]
    to = opts[:to]
    return if from.nil? or to.nil?
    Photo.update_all("album_id = #{to.id}", {:album_id => from.id})
    to.raw_increment :photos_count, from.photos_count
    from.raw_decrement :photos_count, from.photos_count
  end

end
