class AvatarAlbum < Album

	belongs_to :cover, :class_name => 'Avatar'

  belongs_to :user, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'Avatar', :foreign_key => 'album_id', :order => 'created_at DESC'

  has_many :latest_photos, :class_name => 'Avatar', :foreign_key => 'album_id', :limit => 3, :order => "created_at DESC"

  attr_readonly :game_id, :privilege

  # override set_cover method
  def set_cover avatar
    avatar_id = avatar.nil? ? nil : avatar.id
    if cover_id != avatar_id
      update_attributes(:cover_id => avatar_id)
      poster.update_attributes(:avatar_id => avatar_id)
    end
  end

end
