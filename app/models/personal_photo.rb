class PersonalPhoto < Photo

	has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :medium => '50x50>', :small => '27x27>'}
                                  
  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user },
                         :create_conditions => lambda {|user, photo, album| user == photo.poster || (photo.privilege != 4 and album.poster.has_friend?(user)) || false}

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, photo, comment| photo.poster == user || comment.poster == user}, 
                      :create_conditions => lambda {|user, photo| (photo.poster == user) || (photo.privilege == 1) || (photo.privilege == 2 and (photo.poster.has_friend? user or photo.poster.has_same_game_with? user)) || (photo.privilege == 3 and photo.poster.has_friend? user) || false}

  def validate
    return unless thumbnail.blank?
    errors.add_to_base('没有相册') if album_id.blank?
    # 关于poster_id，privilege，game_id都在before_create里被赋值，这里无须检查
  end

end
