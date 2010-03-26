class Topic < ActiveRecord::Base

  belongs_to :forum

  belongs_to :poster, :class_name => 'User'

  has_many :posts, :dependent => :destroy

  acts_as_viewable

  acts_as_random

  validates_presence_of :poster_id, :message => "没有发布者"

  validates_presence_of :forum_id, :message => "没有论坛"

  validates_size_of :subject, :within => 1..800, :too_long => "最长200个字符", :too_short => "最短1个字符"

  validates_size_of :content, :within => 1..8000, :too_long => "最长2000个字符", :too_short => "最短1个字符"

  def self.hot cond={}
    Topic.find(:all, :offset => 0, :limit => 5, :conditions => cond, :order => "posts_count desc")
  end

end
