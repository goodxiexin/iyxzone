class PersonalAlbum < Album

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	named_scope :recent, :conditions => "privilege != 4", :order => 'uploaded_at DESC'

	acts_as_privileged_resources

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, album, comment| album.poster == user || comment.poster == user}, 
                      :create_conditions => lambda {|user, album| (album.poster == user) || (album.privilege == 1) || (album.privilege == 2 and (album.poster.has_friend? user or album.poster.has_same_game_with? user)) || (album.privilege == 3 and album.poster.has_friend? user) || false} 

  def validate
    # check owner
    errors.add_to_base('没有拥有者') if owner_id.blank?
  
    # check privilege
    errors.add_to_base('没有权限') if privilege.blank?

    # check title
    if title.blank?
      errors.add_to_base('标题不能为空')
    elsif title.length >= 100 
      errors.add_to_base('标题最长100个字符')
    end

    # check description
    errors.add_to_base('描述最长500个字符') if description and description.length >= 500
    
    # check game_id
    if game_id.blank?
      errors.add_to_base('请选择游戏类别')
    elsif Game.find(:first, :conditions => {:id => game_id}).nil?
      errors.add_to_base('游戏不存在')
    end
    
    # poster_id在before_create里被赋值，这里不检查
  end

	def record_upload user, photos
	  if user.application_setting.emit_photo_feed and privilege != 4
			recipients = [].concat user.guilds
			recipients.concat user.friends.find_all{|f| f.application_setting.recv_photo_feed}
			deliver_feeds :recipients => recipients, :data => {:ids => photos.map(&:id)}
      update_attribute('uploaded_at', Time.now)
    end
	end	

end

