class PersonalAlbum < Album

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  named_scope :not_empty, :conditions => "photos_count != 0"

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at desc', :dependent => :destroy

  has_many :latest_photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :limit => 3, :order => "created_at DESC"

  acts_as_resource_feeds :recipients => lambda {|album| 
    poster = album.poster
    (poster.is_idol ? poster.fans : []) + poster.friends.find_all {|f| f.application_setting.recv_photo_feed?}
  }

  validate_on_create :game_is_valid

  validates_size_of :title, :within => 1..100

protected

  def game_is_valid
    if game.blank?
      errors.add('game_id', "不存在")
    elsif user and !user.has_game?(game_id)
      errors.add('game_id', "该用户没有这个游戏")
    end
  end

end

