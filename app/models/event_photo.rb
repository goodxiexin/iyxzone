class EventPhoto < Photo

	has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 8.megabytes,
                 :thumbnails => { :large => '100x100>',
                                  :medium => '50x50>',
                                  :small => '27x27>'}

  validates_as_attachment

end
