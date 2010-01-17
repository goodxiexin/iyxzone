class Avatar < Photo

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :medium => '50x50>', :small => '27x27>'}

  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user},
                         :create_conditions => lambda {|user, photo, album| album.poster.has_friend?(user) || album.poster == user}

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, photo, comment| photo.poster == user || comment.poster == user}, 
                      :create_conditions => lambda {|user, photo| (photo.poster == user) || (photo.poster.has_friend? user)} 

  def validate
    return unless thumbnail.blank?
    errors.add_to_base('没有相册') if album_id.blank?
    # 关于poster_id, game_id, privilege都在before_create里被赋值，这里无须检查
  end

  def create_conditions user
    (poster == user) || (poster.has_friend? user)
  end
  
end
