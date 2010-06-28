class MiniBlogImage < ActiveRecord::Base

  belongs_to :mini_blog

  # no thumbnail is needed
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes
                                  
  validates_as_attachment

end
