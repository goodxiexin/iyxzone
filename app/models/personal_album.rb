class PersonalAlbum < Album

  belongs_to :cover, :class_name => 'PersonalPhoto', :conditions => {:verified => [0,1]}

  belongs_to :user, :foreign_key => 'owner_id'

  # 由于每张图片还得删除评论，圈人等等，所以还是用destroy比较方便
  has_many :photos, :class_name => 'PersonalPhoto', :conditions => {:verified => [0,1]}, :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

  has_many :latest_photos, :class_name => 'PersonalPhoto', :conditions => {:verified => [0,1]}, :foreign_key => 'album_id', :limit => 3, :order => "created_at DESC"

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, album, comment| album.poster == user || comment.poster == user}, 
                      :create_conditions => lambda {|user, album| album.available_for? user }

  attr_readonly :owner_id, :poster_id, :poster_id, :game_id

  validates_presence_of :owner_id, :message => "不能为空"

  validates_presence_of :title, :message => "不能为空"

  validates_size_of :title, :within => 1..100, :too_long => "最长100字节", :too_short => "最短1字节", :allow_nil => true

  validates_size_of :description, :within => 0..500, :too_long => "最长500字节", :allow_nil => true 

  validates_inclusion_of :privilege, :in => [1, 2, 3, 4], :message => "只能是1,2,3,4中的一个"

  validates_presence_of :game_id, :message => "不能为空"   

  validate_on_create :game_is_valid

	def record_upload user, photos
    if !photos.blank?
      update_attribute('uploaded_at', Time.now)
    end
	  if user.application_setting.emit_photo_feed == 1 and privilege != 4
      recipients = []
			recipients.concat user.friends.find_all{|f| f.application_setting.recv_photo_feed == 1}
			deliver_feeds :recipients => recipients, :data => {:ids => photos.map(&:id)}
      update_attribute('uploaded_at', Time.now)
    end
	end	

protected

  def game_is_valid
    return if game_id.blank?
    errors.add('game_id', "不存在") unless Game.exists?(game_id)
    errors.add('game_id', "该用户没有这个游戏") unless user.characters.map(&:game_id).include?(game_id)
  end

end

