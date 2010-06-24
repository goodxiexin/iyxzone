class BlogImage < ActiveRecord::Base

  # no thumbnail is needed
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes
                                  
  validates_as_attachment
=begin
  def partitioned_path(*args)
    dir = (attachment_path_id / 10000).to_s
    sub_dir = (attachment_path_id % 10000).to_s
    [dir, sub_dir] + args
  end
=end
end
