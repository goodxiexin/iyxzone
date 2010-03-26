class Forum < ActiveRecord::Base

  belongs_to :guild

  has_many :topics, :dependent => :destroy

  has_many :top_topics, :class_name => 'Topic', :conditions => {:top => 1}, :order => 'created_at desc'

  has_many :normal_topics, :class_name => 'Topic', :conditions => {:top => 0}, :order => 'created_at desc'

  has_many :hot_topics, :class_name => 'Topic', :order => "posts_count DESC", :conditions => ["created_at BETWEEN ? and ?", 1.week.ago.to_s(:db), Time.now.to_s(:db)]

  has_many :posts

  has_many :moderator_forums

  has_many :moderators, :class_name => 'User', :through => :moderator_forums

  acts_as_viewable 

end
