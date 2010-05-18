class Topic < ActiveRecord::Base

  named_scope :top, :conditions => {:top => 1}

  named_scope :normal, :conditions => {:top => 0}

  named_scope :hot, :order => "posts_count DESC", :conditions => ["created_at BETWEEN ? and ?", 1.week.ago.to_s(:db), Time.now.to_s(:db)]

  named_scope :hot
  
  belongs_to :forum

  belongs_to :poster, :class_name => 'User'

  has_many :posts, :dependent => :destroy

  acts_as_viewable

  acts_as_random

  needs_verification :sensitive_columns => [:content, :subject]

  acts_as_shareable :default_title => lambda {|topic| topic.subject}, :path_reg => /\/forums\/[\d]+\/topics\/([\d]+)\/posts/

  acts_as_list :order => 'created_at', :scope => 'forum_id'

  acts_as_abstract :columns => [:content]

  validates_presence_of :poster_id, :message => "没有发布者"

  validates_presence_of :forum_id, :message => "没有论坛"

  validates_size_of :subject, :within => 1..800, :too_long => "最长200个字符", :too_short => "最短1个字符"

  validates_size_of :content, :within => 1..8000, :too_long => "最长2000个字符", :too_short => "最短1个字符"

end
