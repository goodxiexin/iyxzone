class Avatar < Photo

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 8.megabytes,
                 :thumbnails => { :large => '100x100>',
                                  :medium => '50x50>',
                                  :small => '27x27>'}

  validates_as_attachment

	after_create :update_user_and_album

protected

	def update_user_and_album
		return if album.blank?
		album.update_attribute('cover_id', id)
		album.user.update_attribute('avatar_id', id)
	end

end
