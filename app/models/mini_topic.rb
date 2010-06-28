class MiniTopic < ActiveRecord::Base

  has_many :mini_blogs, :through => :mini_blog_topics, :source => :mini_blog

end
