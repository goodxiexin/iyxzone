class GuildPhoto < Photo

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :medium => '50x50>', :small => '27x27>'}

  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user},
                         :create_conditions => lambda {|user, photo, album| album.guild.has_member?(user) }

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, photo, comment| photo.album.poster == user || comment.poster == user}

  def validate
    return unless thumbnail.blank?
    errors.add_to_base('没有相册') if album_id.blank?
    errors.add_to_base('没有上传者') if poster_id.blank?
    # 关于privilege, game_id都在before_create里被赋值，这里不检查
  end


end
