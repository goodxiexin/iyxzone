class GuildPhoto < Photo

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => { :large => '100x100>', :medium => '50x50>', :small => '27x27>'}

  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user},
                         :create_conditions => lambda {|user, photo, album| album.guild.has_people?(user) },
                         :candidates => lambda {|tagger, photo, album| album.guild.people}

  attr_readonly :album_id, :privilege

end
