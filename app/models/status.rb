class Status < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

	acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, status, comment| status.poster == user || comment.poster == user },
                      :create_conditions => lambda {|user, status| status.poster == user || status.poster.has_friend?(user)}

  # 下面这3个要注意顺序
  escape_html :sanitize => :content

  acts_as_emotion_text :columns => [:content]

  acts_as_abstract :columns => [:content]

	acts_as_resource_feeds

  needs_verification 
 
  attr_readonly :poster_id, :content

  validates_presence_of :poster_id, :message => "不能为空"

  validates_presence_of :content, :message => "不能为空"

  validates_size_of :content, :within => 1..420, :too_long => '最长420个字节', :too_short => '最短1个字节'

end
