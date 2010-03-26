class Topic < ActiveRecord::Base

  named_scope :tops, :conditions => {:top => 1}

  named_scope :normals, :conditions => {:top => 0}

  belongs_to :forum

  belongs_to :poster, :class_name => 'User'

  has_many :posts, :dependent => :destroy

  def last_post
    posts.find(:first, :order => 'created_at DESC')
  end

  validates_presence_of :poster_id, :message => "没有发布者"

  validates_presence_of :forum_id, :message => "没有论坛"

  validates_size_of :subject, :within => 1..800, :too_long => "最长200个字符", :too_short => "最短1个字符"

  validates_size_of :blank, :within => 1..8000, :too_long => "最长2000个字符", :too_short => "最短1个字符"

end
