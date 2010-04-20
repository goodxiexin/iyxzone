class News < ActiveRecord::Base

  belongs_to :game

  belongs_to :poster, :class_name => 'User' # this must be an admin

  acts_as_commentable :order => 'created_at ASC', :delete_conditions => lambda {|user, news, comment| user.has_role? 'admin'}

  acts_as_viewable

  acts_as_shareable :path_reg => /\/news\/([\d]+)/, :default_title => lambda {|news| news.title}

  acts_as_diggable

  acts_as_video

  acts_as_random

  # 大致检查下，其他的比如游戏是否存在，类型是否合法我们采取信任传来的参数，毕竟这个是由admin创建的
  validates_presence_of :game_id, :message => "不能为空"

  validates_presence_of :title, :message => "不能为空"

  validates_size_of :title, :within => 1..300, :too_long => "最长300个字节", :too_short => "最短1个字节" 

  validates_presence_of :news_type, :message => "不能为空"

end
