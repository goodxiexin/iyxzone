class MiniImage < ActiveRecord::Base

  belongs_to :mini_blog

  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => {:large => '90x90>'}
                                  
  validates_as_attachment

end
