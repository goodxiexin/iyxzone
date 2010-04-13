class Forum < ActiveRecord::Base

  belongs_to :guild

  # 理论上论坛是没法删除的
  has_many :topics

  has_many :top_topics, :class_name => 'Topic', :conditions => {:top => 1}, :order => 'created_at desc'

  has_many :normal_topics, :class_name => 'Topic', :conditions => {:top => 0}, :order => 'created_at desc'

  has_many :hot_topics, :class_name => 'Topic', :order => "posts_count DESC", :conditions => ["created_at BETWEEN ? and ?", 1.week.ago.to_s(:db), Time.now.to_s(:db)]

  has_many :posts

end
