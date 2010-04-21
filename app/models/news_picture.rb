require 'mime/types'

class NewsPicture < ActiveRecord::Base

  belongs_to :news

  # no thumbnail is needed
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes
                                  
  validates_as_attachment

  def partitioned_path(*args)
    dir = (attachment_path_id / 10000).to_s
    sub_dir = (attachment_path_id % 10000).to_s
    [dir, sub_dir] + args
  end

  def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end

end
