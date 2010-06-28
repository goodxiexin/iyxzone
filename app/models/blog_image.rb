class BlogImage < ActiveRecord::Base

  belongs_to :blog

  # no thumbnail is needed
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes
                                  
  validates_as_attachment

  def self.parse_images blog
    ids = []
    doc = Nokogiri::HTML(blog.content)
    doc.xpath("//img[starts-with(@src, '/blog_images/')]").each do |l|
      l[:src] =~ /\/blog_images\/([\d]+)\/([\d]+)\//
      id = (10000 * $1.to_i + $2.to_i)
      ids << id
    end
    ids
  end

end
