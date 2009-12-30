class Forum < ActiveRecord::Base

  has_many :topics, :dependent => :delete_all

  has_many :posts

  has_many :moderator_forums

  has_many :moderators, :class_name => 'User', :through => :moderator_forums

  belongs_to :last_topic, :class_name => 'Topic'

  belongs_to :guild

  has_many :hot_topics, :class_name => 'Topic', :order => "posts_count DESC",
           :conditions => ["created_at BETWEEN ? and ?", 1.week.ago.to_s(:db), Time.now.to_s(:db)]

end
