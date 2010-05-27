class Post < ActiveRecord::Base

  named_scope :floor_order, :order => "floors DESC"

  belongs_to :poster, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  belongs_to :forum

  belongs_to :topic

  has_many :notices, :as => 'producer', :dependent => :destroy

  needs_verification :sensitive_columns => [:content] 

  validates_presence_of :poster_id, :message => "没有发布者"

  validates_presence_of :topic_id, :message => "没有话题"
  
  validates_size_of :content, :within => 1..8000, :too_long => "最长2000个字符", :too_shot => "最短1个字符"

end
