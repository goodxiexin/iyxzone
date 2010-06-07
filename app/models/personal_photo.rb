class PersonalPhoto < Photo

	has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :medium => '50x50>', :small => '27x27>'}
                                  
  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user },
                         :create_conditions => lambda {|user, photo, album| user == photo.poster || (!photo.is_owner_privilege? and album.poster.has_friend?(user)) || false}

  def self.migrate opts={}
    from = opts[:from]
    to = opts[:to]
    return if from.nil? or to.nil?
    Photo.update_all("album_id = #{to.id}, privilege = #{to.privilege}", {:album_id => from.id})
    to.update_attribute(:photos_count, to.photos_count + from.photos_count)
    from.update_attribute(:photos_count, 0)
  end

end
