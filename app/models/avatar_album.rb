class AvatarAlbum < Album

	belongs_to :cover, :class_name => 'Avatar'

  belongs_to :user, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'Avatar', :dependent => :destroy, :foreign_key => 'album_id', :order => 'created_at DESC'

end
